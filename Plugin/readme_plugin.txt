Building the native plugin

It is easier to use the prebuilt binaries included in the test project. However, should you need to build your own native plugin, use these instructions.

1. Building the plugin for Windows

Solution and Project files are included for Visual Studio 2015 (works with the Free Community Edition). Just open and build.
Make sure the latest GStreamer 1.x is installed (http://gstreamer.freedesktop.org/data/pkg/windows/) and the
GSTREAMER_1_0_ROOT_X86 or GSTREAMER_1_0_ROOT_X86_64 environment variable is defined and points to the proper place.
The project already copies the resulting GstUnityBridge.dll to the Unity\Assets\Plugins\x86 or x86_64 folder of the included Unity project.

2. Building the plugin for Android

Install the latest version of Gstreamer 1.x for Android
- Currently, the maximum supported version is Gstreamer 1.6.4
- You can download the compressed files at https://gstreamer.freedesktop.org/data/pkg/android/
- Extract them (on Windows I suggest using 7Zip to extract, but be sure to run 7Zip in administrator mode)

Some patches for GStreamer are needed ($GST_PREFIX is the folder where you extracted Android GStreamer. For example, `C:\gstreamer\1.0\Android\1.6.4\armv7`):

- Take this into account if using a GStreamer version below 1.6.2: https://bug757732.bugzilla-attachments.gnome.org/attachment.cgi?id=315055
- In $GST_PREFIX/lib/gstreamer-1.0/include/gst/gl/gstglconfig.h, make sure GST_GL_HAVE_GLSYNC is defined to 1
- Define the environment variable GSTREAMER_ROOT_ANDROID as the location where you extracted the Gstreamer files

Setup your build environment
- Install the Android SDK https://developer.android.com/studio/index.html#downloads
- Add the android SDK\tools and android SDK\platform-tools to your PATH
- If you did this correctly the commands "adb --version" and "android" should both work (you may need to restart the console)
- Install the target SDKs you'll be using by opening up Android Studio, going to "Configure/SDK Manager" and selecting the SDKs you want

- Install JDK http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html
- Set the JAVA_HOME environment variable to where you installed the JDK
- Add the /bin and /lib folders to your PATH
- The command "jar" should now work

- Install ANT http://ant.apache.org/bindownload.cgi
- Add ANT to your PATH
- If you did this correctly, the command "ant -version" should work

- Install NDK https://developer.android.com/ndk/downloads/index.html
- Add the NDK to your PATH
- Depending on where you extracted your files, you may need to change the PATH name to have no spaces https://forums.xamarin.com/discussion/9788/error-ndk-path-cannot-contain-space
- If you did this correctly, the command "ndk-build -version" should exit successfully
- Please keep in mind that some versions of Gstreamer supported only a limited subset of NDK versions. Please check the Gstreamer documentation on your version of Gstreamer

Build the plugin
- You'll need to determine the minimum Android API Level for your application. Lower levels will allow supporting more versions, but
won't have all the API functions of a higher version. The lowest supported version for Gstreamer is 9.
- In a command prompt, navigate to the gst-unity-bridge\Plugin directory

You can now either run the bat script "CompileForAndroid" (just make sure t edit in the appropriate android version) Or,

- Run the following:
	- android update project -p . -s --target android-<your-target-api-number-here>
	- ndk-build APP_ABI=armeabi-v7a
- At this point, two libraries are already available in the libs folder: libgstreamer_android.so and libGstUnityBridge.so
- Both must be copied to the Assets\Plugins\Android folder of your Unity project.
	- xcopy /S /Y libs\* ..\Unity\Assets\Plugins\Android\
	- If, in Unity, the inspector window shows nothing when either library is selected, right click them and hit "reimport"
- The first time, you will need to compile the Java part. The easiest way is probably to build the whole project and then generate the JAR file with the needed classes:
	- ant release
	- cd bin/classes
	- jar cvf gub.jar org/*
- And copy the resulting gub.jar file to the Assets\Plugins\Android folder of your Unity project.
	- xcopy /Y gub.jar ..\..\..\Unity\Assets\Plugins\Android

3. Building the plugin for Linux

No facilities are given yet (no Makefiles), but this has worked in the past:

gcc -shared -fPIC -Wl,--no-as-needed `pkg-config --cflags --libs gstreamer-1.0 gstreamer-net-1.0 gstreamer-video-1.0` *.c -o libGstUnityBridge.so

And then copy the resulting libGstUnityBridge.so to the Assets\Plugins\Linux folder of your Unity project.
