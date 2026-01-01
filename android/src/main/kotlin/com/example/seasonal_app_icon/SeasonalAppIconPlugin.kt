package com.example.seasonal_app_icon

import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SeasonalAppIconPlugin */
class SeasonalAppIconPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: Activity? = null
    private var currentIconName: String? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "seasonal_app_icon")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "setIcon" -> handleSetIcon(call, result)
            "getCurrentIcon" -> handleGetCurrentIcon(result)
            "supportsAlternateIcons" -> handleSupportsAlternateIcons(result)
            "getAvailableIcons" -> handleGetAvailableIcons(result)
            else -> result.notImplemented()
        }
    }

    private fun handleSetIcon(call: MethodCall, result: Result) {
        val iconName = call.argument<String?>("iconName")
        val ctx = context ?: run {
            result.success(mapOf("success" to false, "error" to "Context not available"))
            return
        }

        try {
            val packageManager = ctx.packageManager
            val packageName = ctx.packageName

            // Get all activity-aliases from the manifest
            val availableIcons = getActivityAliases(ctx)

            // Disable all activity-aliases first
            availableIcons.forEach { alias ->
                val componentName = ComponentName(packageName, "$packageName.$alias")
                packageManager.setComponentEnabledSetting(
                    componentName,
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    PackageManager.DONT_KILL_APP
                )
            }

            // Enable the main activity or the selected alias
            if (iconName == null) {
                // Reset to default - enable the main activity
                val mainActivityName = getMainActivityName(ctx)
                if (mainActivityName != null) {
                    val mainComponent = ComponentName(packageName, mainActivityName)
                    packageManager.setComponentEnabledSetting(
                        mainComponent,
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }
                currentIconName = null
            } else {
                // Disable main activity and enable the selected alias
                val mainActivityName = getMainActivityName(ctx)
                if (mainActivityName != null) {
                    val mainComponent = ComponentName(packageName, mainActivityName)
                    packageManager.setComponentEnabledSetting(
                        mainComponent,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }

                val aliasComponent = ComponentName(packageName, "$packageName.$iconName")
                packageManager.setComponentEnabledSetting(
                    aliasComponent,
                    PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                    PackageManager.DONT_KILL_APP
                )
                currentIconName = iconName
            }

            result.success(mapOf("success" to true, "iconName" to iconName))
        } catch (e: Exception) {
            result.success(mapOf("success" to false, "error" to (e.message ?: "Unknown error")))
        }
    }

    private fun handleGetCurrentIcon(result: Result) {
        result.success(currentIconName)
    }

    private fun handleSupportsAlternateIcons(result: Result) {
        // Android supports alternate icons via activity-alias
        result.success(true)
    }

    private fun handleGetAvailableIcons(result: Result) {
        val ctx = context ?: run {
            result.success(listOf<String>())
            return
        }
        result.success(getActivityAliases(ctx))
    }

    private fun getActivityAliases(ctx: Context): List<String> {
        val aliases = mutableListOf<String>()
        try {
            val packageInfo = ctx.packageManager.getPackageInfo(
                ctx.packageName,
                PackageManager.GET_ACTIVITIES or PackageManager.GET_DISABLED_COMPONENTS
            )
            packageInfo.activities?.forEach { activityInfo ->
                val name = activityInfo.name
                // Activity aliases typically have a pattern like "packageName.AliasName"
                if (name.contains(".") && !name.endsWith(".MainActivity")) {
                    val aliasName = name.substringAfterLast(".")
                    if (aliasName != "MainActivity") {
                        aliases.add(aliasName)
                    }
                }
            }
        } catch (e: Exception) {
            // Ignore errors
        }
        return aliases
    }

    private fun getMainActivityName(ctx: Context): String? {
        try {
            val packageInfo = ctx.packageManager.getPackageInfo(
                ctx.packageName,
                PackageManager.GET_ACTIVITIES
            )
            packageInfo.activities?.forEach { activityInfo ->
                if (activityInfo.name.endsWith(".MainActivity")) {
                    return activityInfo.name
                }
            }
        } catch (e: Exception) {
            // Ignore errors
        }
        return null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
