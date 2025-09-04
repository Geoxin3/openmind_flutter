# Razorpay required classes
-keep class proguard.annotation.** { *; }
-keepclassmembers class * {
    @proguard.annotation.Keep *;
    @proguard.annotation.KeepClassMembers *;
}

-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
