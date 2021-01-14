import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_weather/blocs/blocs.dart';
import 'package:flutter_weather/models/models.dart' as models;
import 'package:flutter_weather/repositories/repositories.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  MockWeatherRepository mockWeatherRepository;
  var weather = models.Weather(condition: models.WeatherCondition.thunderstorm);

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
  });
  group('GetWeather', () {
    test('check if the initial state is WeatherInitial', () {
      var bloc = WeatherBloc(weatherRepository: mockWeatherRepository);
      expect(bloc.state, WeatherInitial());
      bloc.close();
    });
    blocTest('emits [WeatherLoadInProgress, WeatherLoadSucces] when successful',
        build: () {
          when(mockWeatherRepository.getWeather(any))
              .thenAnswer((_) async => weather);
          return WeatherBloc(weatherRepository: mockWeatherRepository);
        },
        act: (bloc) => bloc.add(WeatherRequested(city: 'london')),
        expect: [
          WeatherLoadInProgress(),
          WeatherLoadSuccess(weather: weather)
        ]);

    blocTest(
        'emits [WeatherLoadInProgress, WeatherLoadFailure] when unsuccessful',
        build: () {
          when(mockWeatherRepository.getWeather(any)).thenThrow(Error());
          return WeatherBloc(weatherRepository: mockWeatherRepository);
        },
        act: (bloc) => bloc.add(WeatherRequested(city: 'london')),
        expect: [
          WeatherLoadInProgress(),
          WeatherLoadFailure(),
        ]);
  });
}
