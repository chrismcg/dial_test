defmodule DialTest do
  defstruct mod: nil

  defmacro dial_test(mod_or_struct, event, runtime) do
    compile = strip_caller(__CALLER__) |> Macro.escape()
    quote do
      case unquote(mod_or_struct) do
        %DialTest{mod: mod} -> mod.hello(unquote(event), unquote(compile), unquote(runtime))
        mod -> mod.hello(unquote(event), unquote(compile), unquote(runtime))
      end
    end
  end

  def hello(_event, _compile_map, _runtime_map) do
  end

  def strip_caller(%Macro.Env{module: mod, function: fun, file: file, line: line}) do
    # %{} # return empty map and dialyzer doesn't crash, even %{foo: :bar} will crash
    %{application: :phoenix, module: mod, function: form_fa(fun), file: file, line: line}
  end

  defp form_fa({name, arity}), do: Atom.to_string(name) <> "/" <> Integer.to_string(arity)
  defp form_fa(nil), do: nil

  def foo do
    dial_test %DialTest{mod: DialTest}, :testing, %{foo: :bar}
  end
end
