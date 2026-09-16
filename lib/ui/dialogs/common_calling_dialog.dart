import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CommonCallDialog extends StatelessWidget {
  final VoidCallback onRegularCall;
  final VoidCallback onFreeCall;

  const CommonCallDialog({
    super.key,
    required this.onRegularCall,
    required this.onFreeCall,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone_in_talk,
                    color: Colors.blueAccent, size: 50),
                const SizedBox(height: 12),
                const Text(
                  "Choose Call Option",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Regular Call
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bfPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onRegularCall();
                  },
                  icon: const Icon(Icons.call),
                  label: const Text("Regular Call"),
                ),
                const SizedBox(height: 10),

                // Free Call
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.primaryColor100)
                    ),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onFreeCall();
                  },
                  icon: const Icon(Icons.wifi_calling,color: AppColors.primaryColor100,),
                  label: Text("Free Call",style: TextStyle(color: AppColors.primaryColor100),),
                ),
              ],
            ),
          ),

          // 🔹 Cancel Icon (top-right)
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red, // background color
                  border: Border.all(color: Colors.red, width: 1.5), // border
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
