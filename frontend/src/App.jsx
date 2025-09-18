import { useState, useEffect } from "react"

// API base URL (replace with your deployed backend API Gateway endpoint)
const API_BASE = "https://dmncn6jn3e.execute-api.us-east-1.amazonaws.com/dev"
export default function App() {
  const [tickets, setTickets] = useState([])
  const [loading, setLoading] = useState(false)

  // Form state
  const [title, setTitle] = useState("")
  const [description, setDescription] = useState("")
  const [priority, setPriority] = useState("low")

  // Fetch tickets on load
  useEffect(() => {
    fetchTickets()
  }, [])

  async function fetchTickets() {
    setLoading(true)
    try {
      const res = await fetch(`${API_BASE}/tickets`)
      const data = await res.json()
      setTickets(data)
    } catch (err) {
      console.error("Error fetching tickets:", err)
    }
    setLoading(false)
  }

  async function handleCreateTicket(e) {
    e.preventDefault()
    const newTicket = { title, description, priority }
    try {
      const res = await fetch(`${API_BASE}/tickets`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(newTicket),
      })
      if (res.ok) {
        setTitle("")
        setDescription("")
        setPriority("low")
        fetchTickets() // refresh list
      }
    } catch (err) {
      console.error("Error creating ticket:", err)
    }
  }

  return (
    <div className="min-h-screen bg-gray-100 p-6">
      <h1 className="text-3xl font-bold mb-6 text-center">🎫 Mini Helpdesk</h1>

      {/* Ticket Form */}
      <form
        onSubmit={handleCreateTicket}
        className="bg-white shadow-md rounded-lg p-6 max-w-md mx-auto mb-8"
      >
        <h2 className="text-xl font-semibold mb-4">Create Ticket</h2>

        <input
          type="text"
          placeholder="Title"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          className="w-full mb-3 p-2 border rounded"
          required
        />

        <textarea
          placeholder="Description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          className="w-full mb-3 p-2 border rounded"
          required
        />

        <select
          value={priority}
          onChange={(e) => setPriority(e.target.value)}
          className="w-full mb-3 p-2 border rounded"
        >
          <option value="low">Low Priority</option>
          <option value="medium">Medium Priority</option>
          <option value="high">High Priority</option>
        </select>

        <button
          type="submit"
          className="w-full bg-blue-600 text-white p-2 rounded hover:bg-blue-700"
        >
          Create Ticket
        </button>
      </form>

      {/* Ticket List */}
      <div className="max-w-2xl mx-auto">
        <h2 className="text-xl font-semibold mb-4">Ticket List</h2>
        {loading ? (
          <p className="text-gray-500">Loading...</p>
        ) : tickets.length === 0 ? (
          <p className="text-gray-500">No tickets found.</p>
        ) : (
          <ul className="space-y-3">
            {tickets.map((ticket) => (
              <li
                key={ticket.id}
                className="bg-white shadow rounded p-4 border"
              >
                <h3 className="font-bold">{ticket.title}</h3>
                <p className="text-sm text-gray-600">{ticket.description}</p>
                <span className="inline-block mt-2 px-2 py-1 text-xs font-medium rounded bg-gray-200">
                  {ticket.priority}
                </span>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  )
}
