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

- ``Validators/Accumulating(_:)-54dl6``
- ``Validators/Accumulating(_:)-6qcyf``

### Enumeration Case Methods

- ``Validators/Case(_:with:file:fileID:line:)-6rsds``
- ``Validators/Case(_:with:file:fileID:line:)-2igc6``
- ``Validators/Case(_:file:fileID:line:validator:)-2th8u``
- ``Validators/Case(_:file:fileID:line:validator:)-2hgqv``

### OneOf Methods

- ``Validators/OneOf(builder:)-8nx46``
- ``Validators/OneOf(builder:)-1nanb``

### Validate Methods

- ``Validators/Validate(_:)-73xhq``
- ``Validators/Validate(_:)-6i3vy``
- ``Validators/Validate(_:with:)-4yq8h``
- ``Validators/Validate(_:with:)-528c1``
- ``Validators/Validate(_:with:)-5qrzz``
- ``Validators/Validate(_:build:)-4cdzq``
- ``Validators/Validate(_:build:)-nuvc``
- ``Validators/Validate(_:with:)-sk1r``

