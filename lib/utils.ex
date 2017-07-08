defmodule Utils do
  def set_resp_body(req_data, body) do
    :wrq.set_resp_body(body, req_data)
  end

  def set_response_code(req_data, code) do
    :wrq.set_response_code(code, req_data)
  end

  def return_req_data(req_data, state) do
    {true, req_data, state}
  end

  def return_body(body, req_data, state) do
    {body, req_data, state}
  end

  def return_state(state, req_data) do
    {req_data, state}
  end

  def bind_result({false, _, _} = tuple, _f) do
    tuple
  end

  def bind_result({{:error, _}, _, _} = tuple, _f) do
    tuple
  end

  def bind_result({{:halt, _}, _, _} = tuple, _f) do
    tuple
  end

  def bind_result({_result, req_data, state} = tuple, f) do
    {_, arity} = :erlang.fun_info(f, :arity)
    case arity do
      1 -> f.(tuple)
      2 -> f.(req_data, state)
    end
  end

  def map_result({false, _, _} = tuple, _f) do
    tuple
  end

  def map_result({{:error, _}, _, _} = tuple, _f) do
    tuple
  end

  def map_result({{:halt, _}, _, _} = tuple, _f) do
    tuple
  end

  def map_result({result, req_data, state} = tuple, f) do
    {_, arity} = :erlang.fun_info(f, :arity)
    case arity do
      1 ->
        f.(tuple)
      2 ->
        f.(req_data, state)
    end
    |> Tuple.insert_at(0, result)
  end
end
