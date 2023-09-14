import RxSwift


class WeatherViewModel {
    
    struct Input {
        let fetchWeatherTrigger: Observable<Void>
    }
    
    struct Output {
        let temperature: Observable<String>
        let errorMessage: Observable<String>
        let weatherDescription: Observable<String>
    }
    
    private let apiKey = "e050990db22df2ab58ab3c620741e32e"
    
    func transform(input: Input) -> Output {
        
        let weatherData = input.fetchWeatherTrigger
            .flatMapLatest {
                fetchWeather(for: "Seoul", apiKey: self.apiKey)
                    .catchAndReturn(nil)
            }
            .share(replay: 1, scope: .whileConnected)
        
        let temperature = weatherData
            .compactMap { weather -> String? in
                if let temp = weather?.main.temp {
                    let temperatureInCelsius = temp - 273.15
                    return "\(Int(temperatureInCelsius))°C"
                }
                return nil
            }
        
        let errorMessage = weatherData
            .compactMap { weather -> String? in
                return weather == nil ? "Failed to fetch weather" : nil
            }
        
        let weatherDescription = weatherData
            .compactMap { weather -> String? in
                return weather?.weather.first?.description
            }
        
        return Output(temperature: temperature, errorMessage: errorMessage, weatherDescription: weatherDescription)
    }
}
