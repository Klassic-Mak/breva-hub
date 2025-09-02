import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ui_design/consts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodDetailScreen extends StatefulWidget {
  final String vendorId;
  const FoodDetailScreen({super.key, required this.vendorId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  Future<Map<String, dynamic>>? _vendorDetails;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _vendorDetails = fetchVendorDetails();
  }

  Future<Map<String, dynamic>> fetchVendorDetails() async {
    final response = await http.get(
      Uri.parse("$baseURL/vendors/${widget.vendorId}"),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load vendor details");
    }
  }

  Future<void> _launchCall(String? phone) async {
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone number not available")),
      );
      return;
    }
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot launch phone dialer")),
      );
    }
  }

  Future<void> _launchMap(double? lat, double? lng) async {
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location not available")),
      );
      return;
    }
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: detailAppbar(context),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _vendorDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No Data Available"));
          }

          final vendor = snapshot.data!;
          final List images = vendor["images"] ?? [];
          final double rating =
              double.tryParse(vendor["rating"].toString()) ?? 0.0;

          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                width: size.width,
                height: size.height,
                color: imageBackground,
                child: Image.asset(
                  "assets/food-delivery/food pattern.png",
                  repeat: ImageRepeat.repeatY,
                  color: imageBackground2,
                ),
              ),
              Container(
                width: size.width,
                height: size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
              ),
              Container(
                width: size.width,
                height: size.height,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 100),
                      // Carousel Image UI from details2.dart
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 320,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: images.isNotEmpty
                              ? CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    height: 320,
                                    enableInfiniteScroll: false,
                                  ),
                                  items: images.map((imgUrl) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl: imgUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Quantity selector
                      Center(
                        child: Container(
                          height: 45,
                          width: 120,
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (quantity > 1) quantity--;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Name, address, price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendor["name"] ?? "Unknown Vendor",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                vendor["address"] ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: vendor["loactionUrl"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      // Info icons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          infoIcon(
                            FontAwesomeIcons.solidStar,
                            rating.toStringAsFixed(1),
                            Colors.amber,
                          ),
                          infoIcon(
                            FontAwesomeIcons.fire,
                            "150k",
                            Colors.red,
                          ),
                          infoIcon(
                            FontAwesomeIcons.clock,
                            "10-15Min",
                            Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Description
                      ReadMoreText(
                        vendor["description"] ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                          color: Colors.black,
                        ),
                        trimLength: 110,
                        trimCollapsedText: "Read More",
                        trimExpandedText: "Read Less",
                        colorClickableText: red,
                        moreStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: red,
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Call & Location buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                            ),
                            icon: const Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              "Call Vendor",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () =>
                                _launchCall(vendor["phoneNumber"] ?? ""),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                            ),
                            icon: const Icon(
                              FontAwesomeIcons.locationArrow,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              "View on Map",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () => _launchMap(
                              vendor["latitude"] is num
                                  ? vendor["latitude"].toDouble()
                                  : null,
                              vendor["longitude"] is num
                                  ? vendor["longitude"].toDouble()
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // Add to Cart Button
              /*     Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 65,
                  color: red,
                  minWidth: 350,
                  child: const Center(
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),*/
            ],
          );
        },
      ),
    );
  }

  Widget infoIcon(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  AppBar detailAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 80,
      forceMaterialTransparency: true,
      actions: [
        const SizedBox(width: 27),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: const Icon(
            Icons.more_horiz_rounded,
            color: Colors.black,
            size: 18,
          ),
        ),
        const SizedBox(width: 27)
      ],
    );
  }
}
