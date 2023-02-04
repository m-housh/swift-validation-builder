# ``Validations/Validators``

@Metadata {
  @DocumentationExtension(mergeBehavior: override)
}

 A namespace for types that serve as validations.

## Overview

The various operators defined as extensions on the ``Validation`` protocol or the
``Validator`` type implement their functionality as classes or structures that extend
this enumeration.  For example the ``Validation/map(_:)-8owqv`` returns a
``Validators/Map`` validation.

## Topics

### Top Level Types

These are types that you generally don't interact with directly, however they
do offer explanation into how to use them and the static methods to create them.

- ``Validators/AccumulatingValidator``
- ``Validators/BoolValidator``
- ``Validators/CaseValidator``
- ``Validators/ComparableValidator``
- ``Validators/ErrorLabelValidator``
- ``Validators/OneOfValidator``
- ``Validators/OptionalValidator``
- ``Validators/OrValidator``
- ``Validators/ValidateValidator``

### Collection Validations

These are types that work on `Collection` types.

- ``Validators/Contains``
- ``Validators/Empty``
- ``Validators/NotEmpty``

### String Validations

- ``Validators/Email``
- ``Validators/Regex``

### Map Operations

These are types that are used to perform `map` operations on existing ``Validation``s or
``AsyncValidation``s.

- ``Validators/Map``
- ``Validators/MapError``
- ``Validators/MapOptional``
- ``Validators/MapValue``

### Optional Validations

- ``Validators/Nil``
- ``Validators/NotNil``

### Utility Types

- ``Validators/Fail``
- ``Validators/Lazy``
- ``Validators/Not``
- ``Validators/Success``

## Type Methods

These methods create concrete versions of some of the top level types.  They infer
whether to be synchonous or asynchronous based on the context.

### Accumulating Methods

- ``Validators/accumulating(_:)-5uoar``
- ``Validators/accumulating(_:)-3mf0r``

### Enumeration Case Methods

- ``Validators/case(_:with:file:fileID:line:)-6g15v``
- ``Validators/case(_:with:file:fileID:line:)-kot0``
- ``Validators/case(_:file:fileID:line:validator:)-40vzm``
- ``Validators/case(_:file:fileID:line:validator:)-9svng``

### OneOf Methods

- ``Validators/oneOf(builder:)-6r0e6``
- ``Validators/oneOf(builder:)-7mxbq``

### Validate Methods

- ``Validators/validate(_:)-70j1m``
- ``Validators/validate(_:)-364v5``
- ``Validators/validate(_:with:)-487rc``
- ``Validators/validate(_:with:)-65q79``
- ``Validators/validate(_:with:)-8xxlw``
- ``Validators/validate(_:with:)-7bb70``
- ``Validators/validate(_:build:)-96v5q``
- ``Validators/validate(_:build:)-5pnod``

