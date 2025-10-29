import Foundation

final class KakaoBookAPI {
    private let apiKey = "85f2abad83f83deecb5e20f8ed81d5a0"
    
    func fetchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let encodeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url: URL = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(encodeQuery)") else {
            print("URL is not correct")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let http = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "KakaoBookAPI", code: -1)))
                return }
            
            guard (200...299).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? ""
                print("❌ HTTP \(http.statusCode) | BODY:", body)
                let err = NSError(domain: "KakaoBookAPI",
                                  code: http.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: body])
                completion(.failure(err))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(BookSearchResponse.self, from: data)
                completion(.success(result.documents))
            } catch {
                if let json = String(data: data, encoding: .utf8) {
                      print("🔎 RAW Kakao Response:\n\(json)")
                  } else {
                      print("🔎 RAW Response: (can't decode string)")
                  }
                  completion(.failure(error))
            }
        }.resume()
    }
}
