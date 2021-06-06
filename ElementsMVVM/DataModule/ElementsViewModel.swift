//
//  JsonViewsViewModel.swift
//  PryanikMVVM
//
//  Created by Владимир on 04.02.2021.
//

import Foundation
import Moya

class ElementsViewModel {
    weak var provider: MoyaProvider<NetworkMenager>!
    
    var serverData: DataView!
    
    var tappedElementText = "После нажатия на элемент здесь появится информация о нём"
    
    required init(provider: MoyaProvider<NetworkMenager>) {
        self.provider = provider
    }
    
    func getDataFromServer(completion: @escaping() -> Void) {
        provider.request(.getData) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(DataView.self)
                    self.serverData = data
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getImageFromServer(url: String, imageData: @escaping(Data) -> Void) {
        provider.request(.getImage(url: url)) { result in
            switch result {
            case .success(let response):
                let data = response.data
                imageData(data)
            case .failure(let error):
                print(error.errorDescription!)
            }
        }
    }
    
    func setTappedElementText(with text: String, completion: @escaping(String) -> Void) {
        tappedElementText = text
        completion(tappedElementText)
    }
    
    func getElementData(for name: String) -> DataDescription? {
        let elementData = serverData.data.filter { $0.name == name}
        guard !elementData.isEmpty else {
            return nil
        }
        
        return elementData[0].data
    }
}
