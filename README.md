# GPURenderKitDemo
基于GPUImage做效果.
由于最近还没有时间写详细的实现的具体方案。现在只是先把效果功能先做出来。后面会把实现的方案补上。


###GLImageMovieUseViewController
这里有视频添加滤镜再混音的操作。一次性生成文件，加速视频的合成时间。

###GLDouYinEffectViewController
这里主要做一些抖音效果的仿写。仿写的不好多多指教。

###FaceViewController
这里面目实现的功能有美颜，大小眼调节，胖瘦脸调节。

**目前里面是在FragmentShader做像素的的调整来实现功能的，后面会放出基于VertexShader做功能的实现（这里可以大家可以想想两种实现方案有什么好处~~）**

由于这里面需要用到人脸106个关键点。

所以大家最好去face++申请一个,免费试用~~每天有5次的免费试用，不然你们都用我的，那我要经常更换。🤣

这里就麻烦各位啦。

更换face++的api\_key和api\_secret很简单。去face++注册一个，选择免费的就可以搞定了~~[face++注册](https://www.faceplusplus.com.cn)。注册好之后更换MGNetAccount.h 里面的api\_key和api\_secret。这样就可以搞定了。



