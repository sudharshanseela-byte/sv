# OwnAI Studio

A personal Android workspace for planning AI-assisted videos.

## What this first version does
- Create a video project title and topic
- Edit scene-by-scene visual prompts and voice-over
- Add and remove scenes
- Copy a complete storyboard or individual scene text
- Dark mobile-first interface

**Important:** This is an MVP foundation, not yet a full AI video generator. AI script/image/voice/video generation and MP4 rendering are not implemented in this build.

## Build an Android APK with GitHub Actions
1. Upload the contents of this folder to your GitHub repository `sudharshanseela-byte/sv` (not the ZIP file itself).
2. Open the repository's **Actions** tab.
3. If prompted, enable GitHub Actions.
4. Select **Build OwnAI Studio Android APK** and run it, or wait for the push-triggered build.
5. Open the completed run and download the `ownai-studio-debug-apk` artifact.
6. Extract the downloaded ZIP on your Android phone and tap `app-debug.apk`.
7. If Android asks, allow your browser or file manager to install unknown apps.

No Play Store upload is needed.

## Build requirements
The workflow uses GitHub-hosted Ubuntu runners, Java 17 and Flutter stable. It runs `flutter analyze` and builds a debug APK.

## Roadmap
1. MVP storyboard app
2. AI script generation
3. Image generation and text-to-speech
4. Video assembly and MP4 export

Open-source model weights are not the same as free compute. High-quality video generation generally needs a GPU server or paid hosted inference. Do not commit API keys or passwords.
