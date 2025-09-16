import React, { useState } from 'react'
import { supabase } from '../supabaseClient'
import { useNavigate } from 'react-router-dom'

function Login({ onLogin }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState(null)
  const navigate = useNavigate()

  const handleLogin = async (e) => {
    e.preventDefault()
    setError(null)

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })

    if (error) {
      setError(error.message)
    } else {
      // Fetch profile role
      const { data: profile, error: profileError } = await supabase
        .from('profiles')
        .select('role')
        .eq('id', data.user.id)
        .single()

      if (profileError) {
        console.error('Error fetching profile:', profileError)
        setError('Could not fetch profile info')
        return
      }

      // Role-based navigation
      if (profile.role === 'admin') {
        navigate('/admin')
      } else if (profile.role === 'staff') {
        navigate('/staff')
      } else {
        navigate('/') // default fallback (citizen or unknown role)
      }

      // Pass user back to App if needed
      onLogin(data.user, profile.role)
    }
  }

  return (
    <div className="min-h-screen flex flex-col justify-center items-center bg-gray-100">
      {/* Header */}
      <div className="absolute top-8 text-center">
        <img
          src="https://upload.wikimedia.org/wikipedia/commons/b/b4/Emblem_of_India_with_transparent_background.png"
          alt="Gov Logo"
          width={100}
          className="h-16 mx-auto mb-2"
        />
        <h1 className="text-2xl font-bold text-gray-800">JanVaani</h1>
        <p className="text-gray-500">Government of Jharkhand</p>
      </div>

      {/* Login Card */}
      <div className="bg-white shadow-lg rounded-xl p-8 w-96 mt-20">
        <h2 className="text-xl font-semibold text-center mb-6 text-gray-700">
          Admin / Staff Login
        </h2>
        <form onSubmit={handleLogin} className="space-y-4">
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            type="submit"
            className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition"
          >
            Login
          </button>
        </form>
        {error && (
          <p className="text-red-600 text-center mt-3 text-sm">{error}</p>
        )}
      </div>
    </div>
  )
}

export default Login
