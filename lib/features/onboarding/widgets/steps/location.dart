import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sociocube/core/services/graphql/graphql_service.dart';
import 'package:sociocube/core/services/graphql/queries/location.graphql.dart';
import 'package:sociocube/core/services/graphql/queries/schema.graphql.dart';
import 'package:sociocube/core/widgets/selector/selector.dart';
import '../../../../core/constants/options.dart';
import '../base_step.dart';
import '../../utils.dart';
import '../../providers/currency_provider.dart';

// ignore: must_be_immutable
class LocationStep extends BaseOnboardingStep {
  LocationStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: "Where are you based?",
         subtitle:
             'Enter the details about your current location to help people find you better',
       );

  ValueNotifier<Country?>? _selectedCountry;
  ValueNotifier<int?>? _selectedCity;

  @override
  Future<bool?> handleNext(WidgetRef ref) async {
    if (_selectedCountry?.value == null) return false;
    final res = await ref
        .read(graphqlServiceProvider)
        .mutate(
          MutationOptions(
            document: documentNodeMutationUpdateUserLocation,
            variables: Variables$Mutation$UpdateUserLocation(
              updatedLocation: Input$UpdateLocation(
                country: _selectedCountry!.value!.id.toDouble(),
                city: _selectedCity!.value!.toDouble(),
              ),
            ).toJson(),
          ),
        );
    if (res.hasException) return false;
    return true;
  }

  @override
  (Widget, ValueNotifier<bool>) buildStepContent(
    BuildContext context,
    WidgetRef ref,
  ) {
    final countries = useState<List<Country>>([]);
    final cities = useState<List<Query$GetCities$cities>>([]);
    final isNextEnabled = useState(false);
    final selectedCountry = useState<Country?>(null);
    final selectedCity = useState<int?>(null);
    final selectedCityName = useState<String?>(null);
    _selectedCountry = selectedCountry;
    _selectedCity = selectedCity;

    useEffect(() {
      // Load countries and fetch IP info in parallel
      loadCountries().then((loadedCountries) {
        countries.value = loadedCountries;

        // Fetch user's country code based on IP
        fetchUserCountryCode().then((res) {
          final (countryCode, city) = res;
          if (countryCode != null && selectedCountry.value == null) {
            selectedCityName.value = city;
            // Find matching country by country code
            try {
              selectedCountry.value = loadedCountries.firstWhere(
                (c) => c.countryCode == countryCode,
              );
            } catch (e) {
              debugPrint('Country not found for code: $countryCode');
            }
          }
        });
      });
      return null;
    }, []);

    useEffect(() {
      if (selectedCountry.value?.id == null) return null;

      var isMounted = true;

      ref.read(onboardingCurrencyProvider.notifier).state =
          selectedCountry.value!.currency;
      ref
          .read(graphqlServiceProvider)
          .query(
            QueryOptions(
              document: documentNodeQueryGetCities,
              variables: Variables$Query$GetCities(
                countryID: selectedCountry.value!.id,
              ).toJson(),
            ),
          )
          .then((result) {
            if (!isMounted) return;
            if (!result.hasException && result.data != null) {
              cities.value = Query$GetCities.fromJson(result.data!).cities;
              try {
                selectedCity.value = cities.value
                    .firstWhere((c) => c.label == selectedCityName.value)
                    .value;
              } catch (e) {
                selectedCityName.value = null;
              }
            }
          });
      return () {
        isMounted = false;
      };
    }, [selectedCountry.value]);

    final options = useMemoized(() {
      return countries.value
          .map((c) => SelectorOption(id: c.id.toString(), value: c.label))
          .toList();
    }, [countries.value]);

    final cityOptions = useMemoized(() {
      return cities.value
          .map((c) => SelectorOption(id: c.value.toString(), value: c.label))
          .toList();
    }, [cities.value]);

    return (
      Column(
        spacing: 14,
        children: [
          Selector(
            label: 'Search Country',
            hint: 'Type to search...',
            options: options,
            defaultText: selectedCountry.value?.label ?? '',
            onSelected: (option) {
              selectedCountry.value = countries.value.firstWhere(
                (c) => c.id.toString() == option.id,
              );
            },
          ),
          Selector(
            label: 'Search City',
            hint: 'Type to search...',
            options: cityOptions,
            defaultText: selectedCity.value != null
                ? selectedCityName.value
                : null,
            onSelected: (option) {
              selectedCity.value = int.parse(option.id);
              isNextEnabled.value = true;
            },
          ),
        ],
      ),
      isNextEnabled,
    );
  }
}
