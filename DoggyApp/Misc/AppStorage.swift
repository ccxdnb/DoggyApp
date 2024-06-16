//
//  AppStorage.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Foundation

enum AppStorageKeys: String , CaseIterable {
    case likedPictures
}

final class AppStorage {
    public static func store<T: Encodable>(_ object: T, for key: AppStorageKeys) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(object)
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }

    public static func data<T: Decodable>(for key: AppStorageKeys) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else { return nil }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Unable to Decode (\(error))")
            return nil
        }
    }

    public static func remove(for key: AppStorageKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    public static func flush() {
        AppStorageKeys.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
