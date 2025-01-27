import React from 'react';
import { useAuth } from '../contexts/AuthContext';

export default function Dashboard() {
  const { user } = useAuth();

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Welcome back, {user?.first_name}!</h1>
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <h3 className="text-lg font-medium text-gray-900">Current Reviews</h3>
            <p className="mt-1 text-sm text-gray-500">View your active performance reviews</p>
          </div>
        </div>
        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <h3 className="text-lg font-medium text-gray-900">Peer Reviews</h3>
            <p className="mt-1 text-sm text-gray-500">Reviews you need to complete for others</p>
          </div>
        </div>
        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="p-5">
            <h3 className="text-lg font-medium text-gray-900">Past Reviews</h3>
            <p className="mt-1 text-sm text-gray-500">Access your review history</p>
          </div>
        </div>
      </div>
    </div>
  );
}