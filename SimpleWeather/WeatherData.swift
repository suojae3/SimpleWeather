//
//  File.swift
//  SimpleWeather
//
//  Created by ㅣ on 2023/09/11.
//

import RxSwift



struct Weather: Codable {
    let main: Main
    let weather: [WeatherCondition]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherCondition: Codable {
    let main: String
    let description: String
}


func fetchWeather(for city: String, apiKey: String) -> Observable<Weather?> {
    return Observable.create { observer in
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Seoul&appid=e050990db22df2ab58ab3c620741e32e"
        
        guard let url = URL(string: urlString) else {
            observer.onError(NSError(domain: "InvalidURL", code: 400, userInfo:  nil))
            return Disposables.create()
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                observer.onError(error)
                return
            }
            
            guard let data = data, let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                observer.onError(NSError(domain: "DecodingError", code: 401, userInfo: nil))
                return
            }
            observer.onNext(weather)
            observer.onCompleted()
        }
        task.resume()
        
        return Disposables.create {
            task.cancel()
        }
    }
}

