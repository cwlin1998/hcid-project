//
//  API.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/7.
//

import SwiftUI
import GooglePlaces

struct API {
    let hostURL = "http://localhost:8000"
    
    // PLAN API
    // not confirmed
    func addPlan(userAccount: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans") else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody: [String: Any] = ["user": userAccount]
        let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRequestBody
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    func getPlan(planId: String, handler: @escaping (Result<Plan, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId) else {
            print("error...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let plan = try encoder.decode(Plan.self, from: data)
                    handler(.success(plan))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    func addDay(planId: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func deletePlan(planId: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func addUser2Plan(planId: String, userAccount: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId + "/users") else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let requestBody: [String: Any] = ["user": userAccount]
        let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRequestBody
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func deleteUserFromPlan(planId: String, userAccount: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId + "/users/" + userAccount) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    func addDestination(planId: String, dayIndex: Int, locationId: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId + "/" + String(dayIndex)) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let requestBody: [String: Any] = ["destination": locationId]
        let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRequestBody
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func deleteDay(planId: String, dayIndex: Int, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId + "/" + String(dayIndex)) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func deleteDestination(planId: String, dayIndex: Int, locationId: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId + "/" + String(dayIndex) + "/" + locationId) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    
    // USER API
    // not confirmed
    func addUser(user: User, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/users") else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonRequestBody = try? JSONEncoder().encode(user)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRequestBody
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    func getUser(userAccount: String, handler: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/users/" + userAccount) else {
            print("error...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let user = try encoder.decode(User.self, from: data)
                    handler(.success(user))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func updateUser(user: User, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/users/" + user.account) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        let jsonRequestBody = try? JSONEncoder().encode(user)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRequestBody
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func addComment(userAccount: String, comment: Comment, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/users/" + userAccount + "/comment") else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let jsonRequestBody = try? JSONEncoder().encode(comment)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRequestBody
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func getComment(userAccount: String, locationId: String, handler: @escaping (Result<Comment, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/users/" + userAccount + "/comment/" + locationId) else {
            print("error...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let comment = try encoder.decode(Comment.self, from: data)
                    handler(.success(comment))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func updateComment(userAccount: String, comment: Comment, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/users/" + userAccount + "/comment/" + comment.locationId) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        let jsonRequestBody = try? JSONEncoder().encode(comment)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRequestBody
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    // not confirmed
    func deleteComment(userAccount: String, locationId: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/users/" + userAccount + "/comment/" + locationId) else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
}

struct GoogleAPI {
    let hostURL = "https://maps.googleapis.com/maps/api/place/details/json"
    func getLocation(locationId: String, handler: @escaping (Result<GooglePlaceDetailsResponse, Error>) -> Void) {
        guard let url = URL(string: hostURL + "?" + "key=AIzaSyBP-OM2AulCwjnQV8IN72HdH-w12umJpxQ" + "&" + "placeid=" + locationId) else {
            print("error...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    // encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let response = try encoder.decode(GooglePlaceDetailsResponse.self, from: data)
                    handler(.success(response))
                } catch {
                    handler(.failure(error))
                }
                
            }
            
        }
        
        task.resume()
    }
}
