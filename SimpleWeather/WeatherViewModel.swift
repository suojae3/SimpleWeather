import RxSwift

final class WeatherViewModel {
    
    // MARK: - Properties
    private let apiManager = APIManager()
    private(set) var city: [String] = ["Seoul", "Paris", "London", "NewYork", "Sydney"]
    private let kelvinToCelsiusOffset: Double = 273.15
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let weatherData = fetchWeatherObservable(trigger: input.fetchWeatherTrigger)
        return Output(
            temperature: temperatureObservable(from: weatherData),
            errorMessage: errorMessageObservable(from: weatherData),
            weatherDescription: weatherDescriptionObservable(from: weatherData)
        )
    }
}

// MARK: - Input & Output
extension WeatherViewModel {
    
    struct Input {
        let fetchWeatherTrigger: Observable<Void>
    }
    
    struct Output {
        let temperature: Observable<String>
        let errorMessage: Observable<String>
        let weatherDescription: Observable<String>
    }
}

// MARK: - Helper Functions
private extension WeatherViewModel {
    
    func fetchWeatherObservable(trigger: Observable<Void>) -> Observable<Weather?> {
        return trigger
            .flatMapLatest {
                self.apiManager.fetchWeather(for: self.city[0])
                    .catchAndReturn(nil)
            }
            .share(replay: 1, scope: .whileConnected)
    }
    
    func temperatureObservable(from data: Observable<Weather?>) -> Observable<String> {
        return data.compactMap { weather in
            guard let temp = weather?.main.temp else { return nil }
            return "\((temp - self.kelvinToCelsiusOffset).rounded())°C"
        }
    }
    
    func errorMessageObservable(from data: Observable<Weather?>) -> Observable<String> {
        return data.compactMap { weather in
            weather == nil ? "Failed to fetch weather" : nil
        }
    }
    
    func weatherDescriptionObservable(from data: Observable<Weather?>) -> Observable<String> {
        return data.compactMap { weather in
            weather?.weather.first?.description
        }
    }
}
