import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bet_trial/widgets/models/country.dart';
import 'package:bet_trial/widgets/modals/modal_item.dart';
import 'package:bet_trial/resources/text.dart';

class SelectCountryModal extends StatefulWidget {
  //Variables
  final Function(Country) selectCountry;
  final Country? selectedCountry;
  final Function resetCountry;

  const SelectCountryModal({
    super.key,
    required this.selectCountry,
    required this.selectedCountry,
    required this.resetCountry,
  });

  @override
  State<SelectCountryModal> createState() {
    return _SelectCountryModalState();
  }
}

class _SelectCountryModalState extends State<SelectCountryModal> {
  //Variables
  final _searchCountryController = TextEditingController();
  List<Country>? countries;
  List<Country>? filtredCountries;

  @override
  void initState() {
    getCountries();
    super.initState();
  }

  @override
  void dispose() {
    _searchCountryController.dispose();
    super.dispose();
  }

  Future<void> getCountries() async {
    try {
      final response = await http.get(
        Uri.parse(AppApiUrls.nationalityUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Country> loadedCountries =
            data.map((item) {
              return Country(
                id: item['id'],
                name: item['Name'],
                image: item['image'],
              );
            }).toList();

        setState(() {
          countries = loadedCountries;
          filtredCountries = loadedCountries;
        });
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (error) {
      print("Error fetching countries: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load countries')),
        );
      }
    }
  }

  void getCountry(String name) {
    if (name.isEmpty) {
      setState(() {
        filtredCountries = countries;
      });
      return;
    }

    setState(() {
      filtredCountries =
          countries!
              .where((c) => c.name.toLowerCase().contains(name.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choose country',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                color: const Color.fromARGB(255, 203, 203, 203),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(
            color: Color.fromARGB(255, 130, 130, 130),
            thickness: 1,
          ),
          SizedBox(height: 10.h),
          TextField(
            onChanged: (value) => getCountry(value),
            controller: _searchCountryController,
            enableSuggestions: false,
            autocorrect: false,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon:
                  (_searchCountryController.text.isEmpty)
                      ? null
                      : IconButton(
                        splashRadius: 1,
                        onPressed: () {
                          setState(() {
                            _searchCountryController.clear();
                            filtredCountries = null;
                            getCountries();
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Color.fromARGB(255, 174, 174, 174),
                        ),
                      ),
              floatingLabelStyle: const TextStyle(color: AppColors.primary),
              labelStyle: const TextStyle(color: AppColors.primary),
              filled: true,
              fillColor: AppColors.cardBackground,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                borderSide: BorderSide(color: Color.fromARGB(255, 83, 83, 83)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              hintText: 'Search',
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 174, 174, 174),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          (() {
            if (filtredCountries == null) {
              return Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return SelectModalItem.sceleton(
                      sceleton: true,
                      reset: () {},
                      isSelected: false,
                    );
                  },
                ),
              );
            } else {
              return Expanded(
                child:
                    (filtredCountries!.isEmpty)
                        ? Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          ),
                        )
                        : Stack(
                          children: [
                            ListView.builder(
                              itemCount: filtredCountries!.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                Country country = filtredCountries![index];
                                return SelectModalItem.country(
                                  country: country,
                                  isSelected:
                                      (widget.selectedCountry != null)
                                          ? (widget.selectedCountry!.name ==
                                              country.name)
                                          : false,
                                  reset: widget.resetCountry,
                                  selectCountry: widget.selectCountry,
                                  sceleton: false,
                                );
                              },
                            ),
                            (widget.selectedCountry != null)
                                ? Positioned(
                                  bottom: 40.h,
                                  right: 0,
                                  left: 0,
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.red,
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.resetCountry();
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                )
                                : const SizedBox(height: 0),
                          ],
                        ),
              );
            }
          }()),
        ],
      ),
    );
  }
}
