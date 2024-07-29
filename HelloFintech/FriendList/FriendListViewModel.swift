//
//  FriendListViewModel.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/22.
//

import Foundation

enum FetchError: Error {
    case badResponse
    case badRequest
}

class FriendListViewModel: NSObject {
    
    var session: Networking!
    
    init(session: Networking) {
        self.session = session
    }

    var frinedList:Observable<[FriendModel]?> = Observable([])
    var invitedfrinedList:Observable<[FriendModel]?> = Observable([])
    
    var searchedFrineds:Observable<[FriendModel]?> = Observable([])
     
    var searching = false
    var isExpand = true
    var isLoading = false
    var error: Error?
    
    func getData<K, R>(for endpoint: Endpoint<K, R>, using requestData: K.RequestData) async throws {
        
        guard let request = endpoint.makeRequest(with: requestData) else {
            throw FetchError.badRequest
        }
        
        do {
            
            self.isLoading = true
            
            let (data, response) = try await session.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw FetchError.badResponse
            }
            
            let decorder = JSONDecoder()
            let models = try decorder.decode(FriendModelRespone.self, from: data)
            
            var array = [FriendModel]()
            var array2 = [FriendModel]()
            
            for model in models.response {
                if model.status == .inviting {
                    array.append(model)
                } else {
                    array2.append(model)
                }
            }
            
            invitedfrinedList.value = array
            frinedList.value = array2
            
            isLoading = false
            
        } catch  {
            isLoading = false
            print("error \(error)")
            self.error = error
        }
    }
    
    func getData2<K, J, R>(for endpoint: Endpoint<K, R>, for endpoint2: Endpoint<J, R>, using requestData: K.RequestData, using requestData2: J.RequestData) async throws {
       
        do {
            isLoading = true
            async let firstData = try await fetchData(for: endpoint, using: requestData)
            async let secondData = try await fetchData(for: endpoint2, using: requestData2)
            let returnData = try await [firstData, secondData]
            
            let decorder = JSONDecoder()
            var models = try decorder.decode(FriendModelRespone.self, from: returnData[0])
            let model2s = try decorder.decode(FriendModelRespone.self, from: returnData[1])
            
            
            models.response.append(contentsOf: model2s.response)

            var array = [FriendModel]()
            var array2 = [FriendModel]()
            
            for model in models.response {
                if model.status == .inviting {
                  
                    if let firstSuchElement = array.first(where: { $0.fid == model.fid }) {
                        if compareDateIsBefore(date1: model.updateDate, date2: firstSuchElement.updateDate) {
                            array.remove(object: firstSuchElement)
                        }
                    }

                    array.append(model)
                } else {
                    
                    if let firstSuchElement = array2.first(where: { $0.fid == model.fid }) {
                        if compareDateIsBefore(date1: model.updateDate, date2: firstSuchElement.updateDate) {
                            array2.remove(object: firstSuchElement)
                        }
                    }
                    
                    array2.append(model)
                }
            }
          
            invitedfrinedList.value = array
            frinedList.value = array2
            isLoading = false
            
        } catch  {
            isLoading = false
            print("error \(error)")
            self.error = error
        }
    }
    
    func fetchData<K, R>(for endpoint: Endpoint<K, R>, using requestData: K.RequestData) async throws -> Data {
       
        guard let request = endpoint.makeRequest(with: requestData) else {
            throw FetchError.badRequest
        }
        
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        return data
    }
    
    func compareDateIsBefore(date1: String, date2: String) -> Bool {
        
        var startDateStr = date1
        var compareDateStr = date2
        
        if !startDateStr.contains("/") {
            startDateStr.insert("/", at: startDateStr.index(startDateStr.startIndex, offsetBy: 4))
            startDateStr.insert("/", at: startDateStr.index(startDateStr.startIndex, offsetBy: 7))
        }
        
        if !compareDateStr.contains("/") {
            compareDateStr.insert("/", at: compareDateStr.index(compareDateStr.startIndex, offsetBy: 4))
            compareDateStr.insert("/", at: compareDateStr.index(compareDateStr.startIndex, offsetBy: 7))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from:startDateStr)
        let compareDate = dateFormatter.date(from:compareDateStr)
  
        guard let startDate = startDate, let compareDate = compareDate else {
            return false
        }
        
        let order = Calendar.current.compare(startDate, to: compareDate, toGranularity: .day)
        
        var dateIsBefore = false

        switch order {
            case .orderedAscending:
                break
            case .orderedDescending:
                dateIsBefore = true
            default:
                break
        }
        
        return dateIsBefore
    }
    
    func cleanData() {
        frinedList.value?.removeAll()
        invitedfrinedList.value?.removeAll()
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}
