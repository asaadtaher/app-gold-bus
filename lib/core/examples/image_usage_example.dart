import 'package:flutter/material.dart';
import '../constants/app_images.dart';
import '../widgets/app_image_widget.dart';
import '../constants/app_constants.dart';

/// مثال على كيفية استخدام الصور والأيقونات في التطبيق
class ImageUsageExample extends StatelessWidget {
  const ImageUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أمثلة على استخدام الصور'),
        leading: AppIconWidget(
          iconName: AppImages.iconBus,
          size: AppConstants.mediumIconSize,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مثال على الشعار
            _buildSection(
              'الشعارات',
              [
                AppImageWidget(
                  imageName: AppImages.logo,
                  height: 100,
                ),
                const SizedBox(height: 10),
                AppImageWidget(
                  imageName: AppImages.logoGoldbusMark,
                  height: 80,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // مثال على الأيقونات
            _buildSection(
              'الأيقونات',
              [
                Row(
                  children: [
                    AppIconWidget(
                      iconName: AppImages.iconBus,
                      size: AppConstants.largeIconSize,
                    ),
                    const SizedBox(width: 10),
                    AppIconWidget(
                      iconName: AppImages.iconCar,
                      size: AppConstants.largeIconSize,
                    ),
                    const SizedBox(width: 10),
                    AppIconWidget(
                      iconName: AppImages.iconGoogle,
                      size: AppConstants.largeIconSize,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // مثال على صور المستخدمين
            _buildSection(
              'صور المستخدمين',
              [
                Row(
                  children: [
                    AppCircularImageWidget(
                      imageName: AppImages.childMale,
                      radius: AppConstants.profileImageSize / 2,
                      borderColor: Colors.gold,
                      borderWidth: 2,
                    ),
                    const SizedBox(width: 10),
                    AppCircularImageWidget(
                      imageName: AppImages.childFemale,
                      radius: AppConstants.profileImageSize / 2,
                      borderColor: Colors.pink,
                      borderWidth: 2,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // مثال على صور الدفع
            _buildSection(
              'طرق الدفع',
              [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    AppImageWidget(
                      imageName: AppImages.paymentMethod1,
                      width: 60,
                      height: 40,
                    ),
                    AppImageWidget(
                      imageName: AppImages.paymentMethod2,
                      width: 60,
                      height: 40,
                    ),
                    AppImageWidget(
                      imageName: AppImages.paymentMethod3,
                      width: 60,
                      height: 40,
                    ),
                    AppImageWidget(
                      imageName: AppImages.paymentMethod4,
                      width: 60,
                      height: 40,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // مثال على صور الخرائط
            _buildSection(
              'أيقونات الخرائط',
              [
                Row(
                  children: [
                    AppImageWidget(
                      imageName: AppImages.schoolMapMarker,
                      width: AppConstants.mapMarkerSize,
                      height: AppConstants.mapMarkerSize,
                    ),
                    const SizedBox(width: 10),
                    AppImageWidget(
                      imageName: AppImages.userMapMarker,
                      width: AppConstants.mapMarkerSize,
                      height: AppConstants.mapMarkerSize,
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // مثال على صور الخطوات
            _buildSection(
              'صور الخطوات',
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        AppImageWidget(
                          imageName: AppImages.stepOne,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 5),
                        const Text('الخطوة الأولى'),
                      ],
                    ),
                    Column(
                      children: [
                        AppImageWidget(
                          imageName: AppImages.stepTwo,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 5),
                        const Text('الخطوة الثانية'),
                      ],
                    ),
                    Column(
                      children: [
                        AppImageWidget(
                          imageName: AppImages.stepThree,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 5),
                        const Text('الخطوة الثالثة'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}
