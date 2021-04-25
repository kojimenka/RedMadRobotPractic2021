//
//  Validator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

// MARK: - Validator Protocol

protocol Validator {
    associatedtype ValueType
    var errorMessage: String { get }
    func isValid(value: ValueType?) -> Bool
}

extension Validator {
    var validator: AnyValidator<ValueType> {
        AnyValidator(validator: self)
    }
}

extension Validator {
    func validate(value: ValueType?) throws {
        if !isValid(value: value) {
            throw ValidationError(message: errorMessage)
        }
    }
}

// MARK: - Validator Errors

struct ValidationError: LocalizedError {
    var message: String
    public var errorDescription: String? {
        message
    }
}

// MARK: - Container for validators of one type

class Validated<Value> {
    private var validators: [AnyValidator<Value>]

    init(_ validators: [AnyValidator<Value>]) {
        self.validators = validators
    }

    public var errors: [ValidationError] {
        var errors: [ValidationError] = []
        validators.forEach {
            do {
                try $0.validate(value: $0.lastValue)
            } catch {
                if let validationError = error as? ValidationError {
                    errors.append(validationError)
                }
            }
        }
        return errors
    }
}

// MARK: - Wrapper to make array of Validation

class AnyValidator<T>: Validator {
    
    private let validator: ValidatorBox<T>
    public var lastValue: T?

    public init<V: Validator>(validator: V) where V.ValueType == T {
        self.validator = ValidatorBoxHelper(validator: validator)
    }

    public var errorMessage: String {
        validator.errorMessage
    }

    public func isValid(value: T?) -> Bool {
        lastValue = value
        return validator.isValid(value: value)
    }
}

private class ValidatorBox<T>: Validator {
    var errorMessage: String {
        fatalError()
    }

    func isValid(value: T?) -> Bool {
        fatalError()
    }
}

private class ValidatorBoxHelper<T, V: Validator>: ValidatorBox<T> where V.ValueType == T {
    private let validator: V

    init(validator: V) {
        self.validator = validator
    }

    override var errorMessage: String {
        validator.errorMessage
    }

    override func isValid(value: T?) -> Bool {
        validator.isValid(value: value)
    }
}
