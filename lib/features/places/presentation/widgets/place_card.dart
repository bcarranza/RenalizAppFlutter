import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'inner_shadow.dart';

class PlaceCard extends StatelessWidget {
  final String photoUrl;
  final String title;
  final String description;

  PlaceCard({
    required this.photoUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 450;
    Color mainColor = Theme.of(context).primaryColor;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Acción a realizar cuando se presiona la Sección 1
                // Por ejemplo, puedes mostrar un mensaje o realizar alguna otra acción.
                print("card");
                context.go('/helpcenters/detailCenter');
              },
              child: InnerShadow( // Envuelve el contenedor interno con InnerShadow
                blur: 10,
                color: Colors.black38,
                offset: Offset(10, 10),
                child: Container(
                  height: isMobile ? 100 : 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 38,
                            fontWeight: FontWeight.bold,
                           shadows: const <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 15.0, 
                              color: Colors.black38,
                            ),
                          ],
                          color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 24,
                           shadows: const <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 15.0, 
                              color: Colors.black38,
                            ),
                          ],
                          color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Acción a realizar cuando se presiona la Sección 2
              // Por ejemplo, puedes navegar a una pantalla de detalles o realizar alguna otra acción.
              print("hola");
            },
            child: Container(
              height: isMobile ? 100 : 200,
              width: isMobile ? 50 : 75,
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                color: mainColor,
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pin_drop,
                    color: Colors.white,
                    size: isMobile ? 24 : 32,
                  ),
                  SizedBox(height: 8),
                
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}