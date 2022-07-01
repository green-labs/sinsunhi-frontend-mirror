module Error = {
  type t = {message: string, @as("type") type_: string}

  @module("react-hook-form")
  external get: (Js.Dict.t<t>, string) => option<t> = "get"
}

module Control = {
  type t
}

module Validation = {
  @unboxed
  type rec t = Any('a): t

  let sync = syncHandler => Any(syncHandler)

  let async = asyncHandler => Any(asyncHandler)
}

module Rules = {
  @deriving({abstract: light})
  type t = {
    @optional
    required: bool,
    @optional
    maxLength: int,
    @optional
    minLength: int,
    @optional
    max: int,
    @optional
    min: int,
    @optional
    pattern: Js.Re.t,
    @optional
    validate: Js.Dict.t<Validation.t>,
    @optional
    valueAsNumber: bool,
    @optional
    shouldUnregister: bool,
  }

  let make = t
}

module ErrorMessage = {
  @module("@hookform/error-message") @react.component
  external make: (
    ~name: string,
    ~errors: Js.Dict.t<Error.t>,
    ~message: string=?,
    ~render: Error.t => React.element=?,
  ) => React.element = "ErrorMessage"
}

module Controller = {
  module OnChangeArg: {
    type rec t

    type kind = Event(ReactEvent.Form.t) | Value(Js.Json.t)

    let event: ReactEvent.Form.t => t
    let value: Js.Json.t => t

    let classify: t => kind
  } = {
    @unboxed
    type rec t = Any('a): t

    type kind = Event(ReactEvent.Form.t) | Value(Js.Json.t)

    let event = eventHandler => Any(eventHandler)
    let value = valueHandler => Any(valueHandler)

    let classify = (Any(unknown)) =>
      unknown->Js.typeof == "object" &&
      unknown->Js.Nullable.return->Js.Nullable.isNullable->not &&
      Obj.magic(unknown)["_reactName"] == "onChange"
        ? Event(Obj.magic(unknown))
        : Value(Obj.magic(unknown))
  }

  type field = {
    name: string,
    onBlur: unit => unit,
    onChange: OnChangeArg.t => unit,
    value: Js.Json.t,
    ref: ReactDOM.domRef,
  }

  type fieldState = {invalid: bool, isTouched: bool, isDirty: bool, error: option<Error.t>}

  type render = {field: field, fieldState: fieldState}

  @module("react-hook-form") @react.component
  external make: (
    ~name: string,
    ~control: Control.t=?,
    ~render: render => React.element,
    ~defaultValue: Js.Json.t=?,
    ~rules: Rules.t=?,
    ~shouldUnregister: bool=?,
  ) => React.element = "Controller"
}

module Register = {
  type t = {
    onChange: ReactEvent.Form.t => unit,
    onBlur: ReactEvent.Focus.t => unit,
    ref: ReactDOM.domRef,
    name: string,
  }
}

module Hooks = {
  module Register = {
    type t = {
      onChange: ReactEvent.Form.t => unit,
      onBlur: ReactEvent.Focus.t => unit,
      ref: ReactDOM.domRef,
      name: string,
    }

    @deriving({abstract: light})
    type config = {
      @optional
      required: bool,
      @optional
      maxLength: int,
      @optional
      minLength: int,
      @optional
      max: int,
      @optional
      min: int,
      @optional
      valueAsNumber: bool,
      @optional
      valueAsDate: bool,
      @optional
      pattern: Js.Re.t,
    }
  }

  module Form = {
    type onSubmit = ReactEvent.Form.t => unit

    type formState = {
      errors: Js.Dict.t<Error.t>,
      isDirty: bool,
      dirtyFields: Js.Dict.t<bool>,
      touchedFields: Js.Dict.t<bool>,
      isSubmitted: bool,
      isSubmitting: bool,
      isSubmitSuccessful: bool,
      isValid: bool,
      isValidating: bool,
      submitCount: int,
    }

    @deriving({abstract: light})
    type config = {
      @optinal
      mode: [#onSubmit | #onBlur | #onChange | #onTouched | #all],
      @optional
      revalidateMode: [#onSubmit | #onBlur | #onChange],
      @optional
      defaultValues: Js.Json.t,
      @optional
      shouldFocusError: bool,
      @optional
      shouldUnregister: bool,
      @optional
      shouldUseNativeValidation: bool,
      @optional
      delayError: int,
      @optional
      criteriaMode: [#firstError | #all],
    }

    type t = {
      clearErrors: (. string) => unit,
      control: Control.t,
      formState: formState,
      getValues: (. array<string>) => Js.Json.t,
      handleSubmit: (. (@uncurry Js.Json.t, ReactEvent.Form.t) => unit) => onSubmit,
      reset: (. option<Js.Json.t>) => unit,
      setError: (. string, Error.t) => unit,
      setFocus: (. string) => unit,
      setValue: (. string, Js.Json.t) => unit,
      resetField: (. string) => unit,
      unregister: (. string) => unit,
      trigger: (. string) => unit,
      register: (. string, option<Register.config>) => Register.t,
      watch: (. array<string>) => Js.Json.t,
    }

    @module("react-hook-form")
    external use: (. ~config: config=?, unit) => t = "useForm"

    @send
    external setErrorAndFocus: (t, string, Error.t, @as(json`{shouldFocus: true }`) _) => unit =
      "setError"

    @send external trigger: (t, string) => unit = "trigger"

    @send external triggerMultiple: (t, array<string>) => unit = "trigger"

    @send
    external triggerAndFocus: (t, string, @as(json`{shouldFocus: true}`) _) => unit = "trigger"
  }

  module Controller = {
    open Controller
    type t = {
      field: field,
      fieldState: fieldState,
      formState: Form.formState,
    }

    @deriving({abstract: light})
    type config = {
      name: string,
      @optional
      control: Control.t,
      @optional
      defaultValue: Js.Json.t,
      @optional
      rules: Rules.t,
      @optional
      shouldUnregister: bool,
    }

    @module("react-hook-form")
    external use: (. string, ~config: config=?, unit) => t = "useController"
  }

  module WatchValues = {
    type rec input<'a, 'b> =
      | Text: input<string, string>
      | Texts: input<array<string>, array<option<string>>>
      | NullableText: input<string, Js.Nullable.t<string>>
      | NullableTexts: input<array<string>, array<Js.Nullable.t<string>>>
      | Checkbox: input<string, bool>
      | Checkboxes: input<array<string>, array<option<bool>>>
      | Object: input<string, Js.Json.t>

    @deriving({abstract: light})
    type config<'a> = {
      name: 'a,
      @optional
      control: Control.t,
      @optional
      defaultValue: Js.Json.t,
    }

    @module("react-hook-form")
    external use: (@ignore input<'a, 'b>, ~config: config<'a>=?, unit) => option<'b> = "useWatch"
  }

  module FormState = {
    @deriving({abstract: light})
    type config = {control: Control.t}

    @module("react-hook-form")
    external use: (. ~config: config) => Form.formState = "useFormState"
  }

  module Context = {
    @module("react-hook-form")
    external use: (. ~config: Form.config=?, unit) => Form.t = "useFormContext"
  }

  module FieldArray = {
    @deriving({abstract: light})
    type config = {
      name: string,
      @optional
      control: Control.t,
      @optional
      shouldUnregister: bool,
    }

    type field = {id: string}

    @deriving({abstract: light})
    type focusOptions = {
      @optional
      shouldFocus: bool,
      @optional
      focusIndex: int,
      @optional
      focusName: string,
    }

    type append = (. Js.Json.t, ~focusOptions: focusOptions=?, unit) => unit
    type insert = (. int, Js.Json.t, ~focusOptions: focusOptions=?, unit) => unit
    type prepend = (. Js.Json.t, ~focusOptions: focusOptions=?, unit) => unit

    type t = {
      fields: array<field>,
      append: append,
      prepend: prepend,
      insert: insert,
      update: (. int, Js.Json.t) => unit,
      remove: (. int) => unit,
    }

    @module("react-hook-form")
    external use: (. ~config: config) => t = "useFieldArray"
  }
}

module Provider = {
  module P = {
    @module("react-hook-form") @react.component
    external make: (~children: React.element) => React.element = "FormProvider"
  }

  @react.component
  let make = (~children, ~methods: Hooks.Form.t) =>
    <ReactUtil.SpreadProps props={methods}> <P> {children} </P> </ReactUtil.SpreadProps>
}

external valueToString: Js.Json.t => string = "%identity"
