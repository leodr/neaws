# flutter_news_app

A new Flutter news application.

## How to successfully compile this

1.: Go to android/app/build.gradle and delete lines 17-19 (key stuff for Google Play Store)

2.: Delete the signingConfigs in build.gradle

3.: Remove line 51 (signingConfig signingConfigs.release)

4.: Add a file named api_key.dart in your lib folder and add your API-Key like this:

    const String API_KEY = "yourkey";
    
You can get your personal API-Key from newsapi.org
