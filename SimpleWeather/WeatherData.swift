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

final class APIManager {
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "e050990db22df2ab58ab3c620741e32e"
    
    func fetchWeather(for city: String) -> Observable<Weather?> {
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)"
        return performRequest(urlString: urlString)
    }
    
    private func performRequest(urlString: String) -> Observable<Weather?> {
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIError.noData)
                    return
                }
                
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    observer.onNext(weather)
                    observer.onCompleted()
                } catch {
                    observer.onError(APIError.decodingError)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
}
