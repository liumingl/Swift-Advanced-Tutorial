import UIKit
import Foundation

enum JSONValue {
  case JSONObject([String:JSONValue])
  case JSONArray([JSONValue])
  case JSONString(String)
  case JSONNumber(NSNumber)
  case JSONBool(Bool)
  case JSONNull
    
    subscript(i: Int) -> JSONValue? {
        get {
            switch self {
            case .JSONArray(let value):
                return value[i]
            default:
                return nil
            }
        }
    }
    
    subscript(key: String) -> JSONValue? {
        get {
            switch self {
            case .JSONObject(let value):
                return value[key]
            default:
                return nil
            }
        }
    }
    
    var object: [String:JSONValue]? {
    switch self {
    case .JSONObject(let value):
      return value
    default:
      return nil
      }
  }
  
  var array: [JSONValue]? {
    switch self {
    case .JSONArray(let value):
      return value
    default:
      return nil
      }
  }
  
  var string: String? {
    switch self {
    case .JSONString(let value):
      return value
    default:
      return nil
      }
  }
  
  var integer: Int? {
    switch self {
    case .JSONNumber(let value):
      return value.integerValue
    default:
      return nil
      }
  }
  
  var double: Double? {
    switch self {
    case .JSONNumber(let value):
      return value.doubleValue
    default:
      return nil
      }
  }
  
  var bool: Bool? {
    switch self {
    case .JSONBool(let value):
      return value
    case .JSONNumber(let value):
      return value.boolValue
    default:
      return nil
      }
  }
    
    static func fromObject(object: AnyObject) -> JSONValue? {
    switch object {
    case let value as NSString:
      return JSONValue.JSONString(value as String)
    case let value as NSNumber:
      return JSONValue.JSONNumber(value)
    case _ as NSNull:
      return JSONValue.JSONNull
    case let value as NSDictionary:
      var jsonObject: [String : JSONValue] = [:]
      for (k, v) in value {
        if let k = k as? String {
          if let v = JSONValue.fromObject(v) {
            jsonObject[k] = v
          } else {
            return nil
          }
        }
      }
      return JSONValue.JSONObject(jsonObject)
    case let value as NSArray:
      var jsonArray: [JSONValue] = []
      for v in value {
        if let v = JSONValue.fromObject(v) {
          jsonArray.append(v)
        } else {
          return nil
        }
      }
      return JSONValue.JSONArray(jsonArray)
    default:
      return nil
    }
  }
}


let json = "{\"success\":true,\"data\":{\"numbers\":[1,2,3,4,5],\"animal\":\"dog\"}}"

if let jsonData = (json as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
    var parsed: AnyObject?
    do {
        parsed = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
        
    }catch {
        print("格式化数据失败！")
    }
    
    // Actual JSON parsing section
    if let parsed = JSONValue.fromObject(parsed!) {
        if parsed["success"]?.bool == true {
            if let numbsers = parsed["data"]?["numbers"]?.array {
                print(numbsers)
                print(numbsers[0])
            }
            if let animal = parsed["data"]?["animal"]?.string {
                print(animal)
            }
        }
    }
}


//if let jsonData = (json as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
//    var parsed: AnyObject?
//    do {
//        parsed = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
//        
//    }catch {
//        print("格式化数据失败！")
//    }
//  
//  // Actual JSON parsing section
//  if let parsed = parsed as? [String:AnyObject] {
//    if let success = parsed["success"] as? NSNumber {
//      if success.boolValue == true {
//        if let data = parsed["data"] as? NSDictionary {
//          if let numbers = data["numbers"] as? NSArray {
//            print(numbers)
//          }
//          if let animal = data["animal"] as? NSString {
//            print(animal)
//          }
//        }
//      }
//    }
//  }
//}