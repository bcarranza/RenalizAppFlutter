import 'package:flutter/material.dart';

import 'inner_shadow.dart';

class PlaceCard extends StatelessWidget {
  final String title;
  final String description;
  final String photoUrl;

  const PlaceCard(this.title, this.description, this.photoUrl, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isMobile = screenWidth <= 450;

    const customFont = TextStyle(
      fontFamily: 'Helvetica',
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InnerShadow(
          blur: 15,
          color: Colors.black38,
          offset: const Offset(20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: isMobile ? screenHeight * 0.2 : screenHeight * 0.3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(1.0),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10.0),
                      bottom: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: customFont.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile
                                ? screenHeight * 0.025
                                : screenHeight * 0.03,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                description,
                                style: customFont.copyWith(
                                  fontSize: isMobile
                                      ? screenHeight * 0.02
                                      : screenHeight * 0.025,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color:Color(0xFF00629D), 
                              ),
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.white,
                                size: isMobile
                                    ? screenHeight * 0.03
                                    : screenHeight * 0.035, // Tamaño más grande
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
