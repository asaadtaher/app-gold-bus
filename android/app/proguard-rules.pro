# Flutter ProGuard Rules for Gold Bus App
# Security and Obfuscation Configuration

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Google Sign-In
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Keep location services
-keep class com.google.android.gms.location.** { *; }
-keep class com.google.android.gms.maps.** { *; }

# Keep image picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# Keep file picker
-keep class io.flutter.plugins.filepicker.** { *; }

# Keep contacts
-keep class io.flutter.plugins.contacts.** { *; }

# Keep phone caller
-keep class io.flutter.plugins.phonecaller.** { *; }

# Keep URL launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Keep local notifications
-keep class com.dexterous.** { *; }

# Security: Remove debug information
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Security: Remove System.out.println
-assumenosideeffects class java.io.PrintStream {
    public void println(%);
    public void println(**);
}

# Security: Obfuscate class names
-repackageclasses ''
-allowaccessmodification
-optimizations !code/simplification/arithmetic

# Security: Remove source file names
-renamesourcefileattribute SourceFile

# Security: Keep only necessary methods
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Security: Remove unused resources
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Security: Obfuscate string constants
-adaptclassstrings
-adaptresourcefilenames
-adaptresourcefilecontents

# Security: Remove line numbers
-renamesourcefileattribute SourceFile

# Security: Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Security: Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Security: Keep serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Security: Remove logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Security: Obfuscate package names
-repackageclasses 'a'
-allowaccessmodification
-optimizations !code/simplification/arithmetic

# Security: Remove debug attributes
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

# Security: Keep only necessary annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Security: Remove unused code
-dontwarn **
-ignorewarnings
