enum ApiError: Error {
    case malformedUrl
    case dataMissing
    case other(error: Error)
    
    var localizedDescription: String {
        switch self {
        case .malformedUrl:
            return "URL is malformed"
        case .dataMissing:
            return "Data is missing"
        case .other(let error):
            return error.localizedDescription
        }
    }
}

extension ApiError: Equatable {
    static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        switch (lhs, rhs) {
        case (.malformedUrl, .malformedUrl):
            return true
        case (.dataMissing, .dataMissing):
            return true
        case (.other(let lhsError), .other(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
