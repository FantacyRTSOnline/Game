/// A client is a player or AI that is connected to the server.
pub struct Client{
    /// If the client is a human or AI.
    pub is_human: bool,
    /// The state of the client's connection to the server.
    pub state: ClientState,
}

pub enum ClientState
{
    /// The client is connected to the server.
    Connected,
    /// The client is disconnected from the server.
    Disconnected,
    /// The client is connecting to the server.
    Connecting,
    /// The client is disconnecting from the server.
    Disconnecting,
}

impl Client
{
    /// Connect to the server.
    pub fn connect(&mut self)
    {
        self.state = ClientState::Connecting;
        // TODO: Connect to the server.
        self.state = ClientState::Connected;
    }

    /// Disconnect from the server.
    pub fn disconnect(&mut self)
    {
        self.state = ClientState::Disconnecting;
        // TODO: Disconnect from the server and clean up resources.
        self.state = ClientState::Disconnected;
    }
}