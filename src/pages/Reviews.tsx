import React from 'react';

export default function Reviews() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Performance Reviews</h1>
      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          <li className="px-6 py-4">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-lg font-medium text-gray-900">2024 Annual Review</h2>
                <p className="text-sm text-gray-500">Status: In Progress</p>
              </div>
              <button className="bg-indigo-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-indigo-700">
                Continue
              </button>
            </div>
          </li>
        </ul>
      </div>
    </div>
  );
}