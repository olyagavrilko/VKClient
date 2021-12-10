//
//  Results+Extension.swift
//  VKClient
//
//  Created by Olya Ganeva on 10.12.2021.
//

import RealmSwift

extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }
