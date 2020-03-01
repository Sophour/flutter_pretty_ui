package com.sophour.meditivitytest2

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.dart.DartExecutor
import android.content.Context
import android.icu.lang.UCharacter.GraphemeClusterBreak.T



class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        // Instantiate a FlutterEngine.
        val flutterEngine = FlutterEngine(context.applicationContext)

        // Start executing Dart code to pre-warm the FlutterEngine.
        flutterEngine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        )

        return flutterEngine
    }
}
