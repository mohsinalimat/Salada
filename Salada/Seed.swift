//
//  Seed.swift
//  Salada
//
//  Created by nori on 2017/05/29.
//  Copyright © 2017年 Stamp. All rights reserved.
//

import Firebase

public struct ObjectError: Error {
    enum ErrorKind {
        case invalidId
        case invalidFile
        case timeout
    }
    let kind: ErrorKind
    let description: String
}

open class Seed: NSObject {

    enum ValueType {

        case bool(String, Bool)
        case int(String, Int)
        case uint(String, UInt)
        case float(String, Float)
        case double(String, Double)
        case string(String, String)
        case date(String, TimeInterval, Date)
        case url(String, String, URL)
        case array(String, [Any])
        case set(String, [String: Bool], Set<String>)
        case relation(String, [String: Bool], Relation)
        case file(String, File)
        case object(String, Any)
        case null

        init(key: String, value: Any) {
            switch value.self {
            case is Bool:
                if let value: Bool = value as? Bool {
                    self = .bool(key, Bool(value))
                    return
                }
            case is Int:
                if let value: Int = value as? Int {
                    self = .int(key, Int(value))
                    return
                }
            case is Int8:
                if let value: Int8 = value as? Int8 {
                    self = .int(key, Int(value))
                    return
                }
            case is Int16:
                if let value: Int16 = value as? Int16 {
                    self = .int(key, Int(value))
                    return
                }
            case is Int32:
                if let value: Int32 = value as? Int32 {
                    self = .int(key, Int(value))
                    return
                }
            case is Int64:
                if let value: Int64 = value as? Int64 {
                    self = .int(key, Int(value))
                    return
                }
            case is UInt:
                if let value: UInt = value as? UInt {
                    self = .int(key, Int(value))
                    return
                }
            case is Float:
                if let value: Float = value as? Float {
                    self = .float(key, Float(value))
                    return
                }
            case is Double:
                if let value: Double = value as? Double {
                    self = .double(key, Double(value))
                    return
                }
            case is String:
                if let value: String = value as? String {
                    self = .string(key, value)
                    return
                }
            case is URL:
                if let value: URL = value as? URL {
                    self = .url(key, value.absoluteString, value)
                    return
                }
            case is Date:
                if let value: Date = value as? Date {
                    self = .date(key, value.timeIntervalSince1970, value)
                    return
                }
            case is [Any]:
                if let value: [Any] = value as? [Any], !value.isEmpty {
                    self = .array(key, value)
                }
            case is Set<String>:
                if let value: Set<String> = value as? Set<String>, !value.isEmpty {
                    self = .set(key, value.toKeys(), value)
                    return
                }
            case is Relation:
                if let value: Relation = value as? Relation {
                    self = .relation(key, value.toKeys(), value)
                    return
                }
            case is File:
                if let value: File = value as? File {
                    self = .file(key, value)
                    return
                }
            case is [String: Any]:
                if let value: [String: Any] = value as? [String: Any] {
                    self = .object(key, value)
                    return
                }
            case is [AnyHashable: Any]:
                if let value: [String: Any] = value as? [String: Any] {
                    self = .object(key, value)
                    return
                }
            default: self = .null
            }
            print("\(value) is not valid Salada's Value type.")
            self = .null
        }

        init(key: String, mirror: Mirror, snapshot: [AnyHashable: Any]) {
            let subjectType: Any.Type = mirror.subjectType
            if subjectType == Bool.self || subjectType == Bool?.self {
                if let value: Bool = snapshot[key] as? Bool {
                    self = .bool(key, Bool(value))
                    return
                }
            } else if subjectType == Int.self || subjectType == Int?.self {
                if let value: Int = snapshot[key] as? Int {
                    self = .int(key, Int(value))
                    return
                }
            } else if subjectType == UInt.self || subjectType == UInt?.self {
                if let value: UInt = snapshot[key] as? UInt {
                    self = .uint(key, UInt(value))
                    return
                }
            } else if subjectType == Float.self || subjectType == Float?.self {
                if let value: Float = snapshot[key] as? Float {
                    self = .float(key, Float(value))
                    return
                }
            } else if subjectType == Double.self || subjectType == Double?.self {
                if let value: Double = snapshot[key] as? Double {
                    self = .double(key, Double(value))
                    return
                }
            } else if subjectType == String.self || subjectType == String?.self {
                if let value: String = snapshot[key] as? String {
                    self = .string(key, value)
                    return
                }
            } else if subjectType == URL.self || subjectType == URL?.self {
                if
                    let value: String = snapshot[key] as? String,
                    let url: URL = URL(string: value)  {
                    self = .url(key, value, url)
                    return
                }
            } else if subjectType == Date.self || subjectType == Date?.self {
                if let value: Double = snapshot[key] as? Double {
                    let date: Date = Date(timeIntervalSince1970: TimeInterval(value))
                    self = .date(key, value, date)
                    return
                }
            } else if subjectType == [Int].self || subjectType == [Int]?.self {
                if let value: [Int] = snapshot[key] as? [Int], !value.isEmpty {
                    self = .array(key, value)
                    return
                }
            } else if subjectType == [String].self || subjectType == [String]?.self {
                if let value: [String] = snapshot[key] as? [String], !value.isEmpty {
                    self = .array(key, value)
                    return
                }
            } else if subjectType == [Any].self || subjectType == [Any]?.self {
                if let value: [Any] = snapshot[key] as? [Any], !value.isEmpty {
                    self = .array(key, value)
                    return
                }
            } else if subjectType == Set<String>.self || subjectType == Set<String>?.self {
                if let value: [String: Bool] = snapshot[key] as? [String: Bool], !value.isEmpty {
                    self = .set(key, value, Set<String>(value.keys))
                    return
                }
            } else if subjectType == Relation.self || subjectType == Relation?.self {
                if let value: [String: Bool] = snapshot[key] as? [String: Bool], !value.isEmpty {
                    self = .relation(key, value, Relation(value.keys))
                } else {
                    self = .relation(key, [:], Relation())
                }
                return
            } else if subjectType == [String: Any].self || subjectType == [String: Any]?.self {
                if let value: [String: Any] = snapshot[key] as? [String: Any] {
                    self = .object(key, value)
                    return
                }
            } else if subjectType == [AnyHashable: Any].self || subjectType == [AnyHashable: Any]?.self {
                if let value: [AnyHashable: Any] = snapshot[key] as? [AnyHashable: Any] {
                    self = .object(key, value)
                    return
                }
            } else if subjectType == File.self || subjectType == File?.self {
                if let value: String = snapshot[key] as? String {
                    let file: File = File(name: value)
                    self = .file(key, file)
                    return
                }
            } else {
                self = .null
            }
            self = .null
        }
    }

    open class var _version: String {
        return "v1"
    }

    open class var _modelName: String {
        return String(describing: Mirror(reflecting: self).subjectType).components(separatedBy: ".").first!.lowercased()
    }

    open class var _path: String {
        return "\(self._version)/\(self._modelName)"
    }

}
