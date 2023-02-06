# ``Validations/Validators``

@Metadata {
  @DocumentationExtension(mergeBehavior: override)
}

 A namespace for types that serve as validations.

## Overview

The various operators defined as extensions on the ``Validation`` protocol, the
``Validator`` type, and the ``AsyncValidator`` type, they implement their functionality as 
classes or structures that extend this enumeration.  For example the ``Validation/map(_:)-8owqv`` 
returns a ``Validators/Map`` validation.

These are generally not interacted with directly, instead use methods on concrete validation types
for these to be generated properly for the context.

## Topics

### Top Level Types

- ``Validators/BoolValidator``
- ``Validators/CaseValidator``
- ``Validators/ComparableValidator``
- ``Validators/ErrorLabelValidator``
- ``Validators/OptionalValidator``

### Collection Validations

These are types that work on `Collection` types.

- ``Validators/ContainsValidator``
- ``Validators/EmptyValidator``
- ``Validators/NotEmptyValidator``

### String Validations

- ``Validators/EmailValidator``
- ``Validators/RegexValidator``

### Map Operations

These are types that are used to perform `map` operations on existing ``Validation``s or
``AsyncValidation``s.

- ``Validators/Map``
- ``Validators/MapError``
- ``Validators/MapOptional``
- ``Validators/MapValue``

### Optional Validations

- ``Validators/NilValidator``
- ``Validators/NotNilValidator``

### Utility Types

- ``Validators/FailingValidator``
- ``Validators/LazyValidator``
- ``Validators/NotValidator``
- ``Validators/SuccessValidator``
