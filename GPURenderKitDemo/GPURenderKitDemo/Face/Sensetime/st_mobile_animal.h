#ifndef INCLUDE_STMOBILE_ST_MOBILE_ANIMAL_H_
#define INCLUDE_STMOBILE_ST_MOBILE_ANIMAL_H_

#include "st_mobile_common.h"

/// 该文件中的API不保证线程安全.多线程调用时,需要确保安全调用.例如在 create handle 没有执行完就执行 process 可能造成crash;在 process 执行过程中调用 destroy 函数可能会造成crash.

/// @defgroup st_mobile_tracker_cat
/// @brief cat keypoints tracking interfaces
/// This set of interfaces processing cat keypoints tracking routines
///
/// @{


typedef struct st_mobile_animal_face_t {
	int id;                 ///<  每个检测到的脸拥有唯一的ID.跟踪丢失以后重新被检测到,会有一个新的ID
	st_rect_t rect;         ///< 代表面部的矩形区域
	float score;            ///< 置信度
	st_pointf_t *p_key_points;  ///< 关键点
	int key_points_count;       ///< 关键点个数
} st_mobile_animal_face_t, *p_st_mobile_animal_face_t;

/// @brief 创建实时猫脸关键点跟踪句柄
/// @param[in] model_path 模型文件的绝对路径或相对路径,例如models/cat.model
/// @param[in] config 配置选项 例如ST_MOBILE_TRACKING_MULTI_THREAD,默认使用双线程跟踪,实时视频预览建议使用该配置.
///     使用单线程算法建议选择（ST_MOBILE_TRACKING_SINGLE_THREAD)
///     图片版建议选择ST_MOBILE_DETECT_MODE_IMAGE
/// @parma[out] handle 猫脸跟踪句柄,失败返回NULL
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_tracker_animal_face_create(
const char *model_path,
unsigned int config,
st_handle_t *handle
);

/// @brief cat参数类型
typedef enum {
	/// 设置检测到的最大猫脸数目N,持续track已检测到的N个猫脸直到猫脸数小于N再继续做detect.默认32
	ST_MOBILE_CAT_LIMIT = 1,
	/// 设置tracker每多少帧进行一次detect.
	ST_MOBILE_CAT_DETECT_INTERVAL_LIMIT = 2,
	/// 设置猫脸跟踪的阈值
	ST_MOBILE_CAT_THRESHOLD = 3
} st_animal_face_param_type;

/// @brief 设置参数
/// @param[in] handle 已初始化的猫脸跟踪句柄
/// @param[in] type 参数关键字,例如ST_MOBILE_CAT_LIMIT
/// @param[in] value 参数取值
/// @return 成功返回ST_OK,错误则返回错误码,错误码定义在st_mobile_common.h 中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_tracker_animal_face_setparam(
st_handle_t handle,
st_animal_face_param_type type,
float value
);


/// @brief 重置实时猫脸关键点跟踪,清空track造成的缓存,重新检测下一帧图像中的猫脸并跟踪,建议在两帧图片相差较大时使用
/// @param [in] handle 已初始化的实时目标猫脸关键点跟踪句柄
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_tracker_animal_face_reset(
st_handle_t handle
);

/// @brief 对连续视频帧进行实时快速猫脸关键点跟踪
/// @param[in] handle 已初始化的实时猫脸跟踪句柄
/// @param[in] image 用于检测的图像数据
/// @param[in] pixel_format 用于检测的图像数据的像素格式. 推荐使用GRAY8、NV12、NV21、YUV420P
/// @param[in] image_width 用于检测的图像的宽度(以像素为单位)
/// @param[in] image_height 用于检测的图像的高度(以像素为单位)
/// @param[in] image_stride 用于检测的图像的跨度(以像素为单位),即每行的字节数；目前仅支持字节对齐的padding,不支持roi
/// @param[in] orientation 视频中猫脸的方向
/// @param[out] p_faces_array 检测到的猫脸信息数组,api负责管理内存,会覆盖上一次调用获取到的数据
/// @param[out] p_faces_count 检测到的猫脸数量
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_tracker_animal_face_track(
st_handle_t handle,
const unsigned char *image,
st_pixel_format pixel_format,
int image_width,
int image_height,
int image_stride,
st_rotate_type orientation,
st_mobile_animal_face_t **p_faces_array,
int *p_faces_count
);

/// @brief 销毁已初始化的猫脸跟踪句柄
/// @param[in] handle 已初始化的猫脸跟踪句柄
ST_SDK_API void
st_mobile_tracker_animal_face_destroy(
st_handle_t handle
);

/// @brief 镜像animal检测结果.
/// @param[in] image_width 检测animal_face的图像的宽度(以像素为单位)
/// @param[in,out] p_faces_array 需要镜像的animal_face检测结果
ST_SDK_API void
st_mobile_animal_face_mirror(
	int image_width,
	st_mobile_animal_face_t *p_faces_array,
	int p_faces_count
);

/// @brief 旋转animal_face检测结果.
/// @param[in] image_width 检测animal_face的图像的宽度(以像素为单位)
/// @param[in] image_height 检测animal_face的图像的宽度(以像素为单位)
/// @param[in] orientation 顺时针旋转的角度
/// @param[in,out] p_faces_array 需要旋转的animal_face检测结果
ST_SDK_API void
st_mobile_animal_face_rotate(
	int image_width,
	int image_height,
	st_rotate_type orientation,
	st_mobile_animal_face_t *p_faces_array,
	int faces_count
);
/// @brief 放大/缩小animal_face检测结果.
/// @param[in] scale 缩放的尺度
/// @param[in,out] p_faces_array 需要缩放的animal_face检测结果
ST_SDK_API
void st_mobile_animal_face_resize(
	float scale,
	st_mobile_animal_face_t *p_faces_array,
	int faces_count
);

/// @}

#endif // INCLUDE_STMOBILE_ST_MOBILE_ANIMAL_H_
