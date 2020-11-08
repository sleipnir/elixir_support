defmodule CloudState.EventSourced do
  defmacro __using__(_args) do
    quote do
      @behaviour CloudState.EventSourced
      @entity_type "cloudstate.eventsourced.EventSourced"
      @before_compile {unquote(__MODULE__), :__before_compile__}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def get_entity_type, do: @entity_type
    end
  end

  @callback init(context :: Context.t()) ::
              {:ok, context_with_state :: Context.t()} | {:error, reason :: term}

  @callback handle_command(service :: term, request :: term, context :: Context.t()) ::
              {:ok, result :: term, context :: Context.t()}
              | {:error, reason :: term, context :: Context.t()}

  @callback handle_event(event_type :: term, request :: term, context :: Context.t()) ::
              {:ok, context_with_state :: Context.t()}
              | {:error, reason :: term, context :: Context.t()}

  defmodule Context do
    @type t :: %__MODULE__{
            name: String.t(),
            entity: any,
            persistence_id: String.t(),
            entity_id: integer,
            events: [any],
            forwards: [any],
            state: any
          }

    defstruct [:name, :entity, :persistence_id, :entity_id, :events, :forwards, :state]
  end
end
