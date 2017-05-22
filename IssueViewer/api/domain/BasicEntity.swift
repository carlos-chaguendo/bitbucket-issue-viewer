
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

public class BasicEntity: Object, Mappable {

	public required init(map: Map) {
		super.init()
	}

	required public init() {
		super.init()
	}

	required public init(realm: RLMRealm, schema: RLMObjectSchema) {
		super.init(realm: realm, schema: schema)
	}

	required public init(value: Any, schema: RLMSchema) {
		super.init(value: value, schema: schema)
	}

	public override init(value: Any) {
		super.init(value: value)
	}

	public func mapping(map: Map) {

	}



}




public class ISO8601ExtendedDateTransform: TransformType {
	public typealias Object = Date
	public typealias JSON = String

	public let dateFormatter: DateFormatter

	public convenience init() {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"
		self.init(formatter)
	}


	public init(_ dateFormatter: DateFormatter) {
		self.dateFormatter = dateFormatter
	}

	public func transformFromJSON(_ value: Any?) -> Date? {
		if let dateString = value as? String {
			let d = dateFormatter.date(from: dateString)
			return d as Date?;
		}
		return nil
	}

	public func transformToJSON(_ value: Date?) -> String? {
		if value != nil {
			let i = value!.timeIntervalSince1970;
			let d: Date = Date(timeIntervalSince1970: i)

			return dateFormatter.string(from: d)
		}
		return nil
	}
}

