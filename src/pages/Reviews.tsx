import React, { useState } from 'react';
import Modal from '../components/Modal'; // Import du composant modal (à créer)

export default function Reviews() {
    const [isModalOpen, setIsModalOpen] = useState(false);

    const handleOpenModal = () => setIsModalOpen(true);
    const handleCloseModal = () => setIsModalOpen(false);

    const handleSubmitReview = () => {
        console.log('Nouvelle revue soumise');
        setIsModalOpen(false); // Ferme le modal après soumission
    };

    return (
        <div className="space-y-6">
            <h1 className="text-2xl font-semibold text-gray-900">
                Performance Reviews
            </h1>
            <div className="bg-white shadow overflow-hidden sm:rounded-md">
                <ul className="divide-y divide-gray-200">
                    <li className="px-6 py-4">
                        <div className="flex items-center justify-between">
                            <div>
                                <h2 className="text-lg font-medium text-gray-900">
                                    2024 Annual Review
                                </h2>
                                <p className="text-sm text-gray-500">
                                    Status: In Progress
                                </p>
                            </div>
                            <button
                                className="bg-indigo-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-indigo-700"
                            >
                                Continue
                            </button>
                        </div>
                    </li>
                </ul>
            </div>

            {/* Bouton flottant en bas à droite */}
            <div className="fixed bottom-6 right-6">
                <button
                    onClick={handleOpenModal}
                    className="bg-indigo-600 text-white px-6 py-4 rounded-full shadow-lg text-sm font-medium hover:bg-indigo-700"
                >
                    + Nouvelle revue
                </button>
            </div>

            {/* Modal */}
            {isModalOpen && (
                <Modal onClose={handleCloseModal}>
                    <h2 className="text-lg font-medium text-gray-900 mb-4">
                        Nouvelle revue
                    </h2>
                    <input
                        type="text"
                        placeholder="Nom de la revue"
                        className="w-full border rounded-md p-2 mb-4"
                    />
                    <textarea
                        placeholder="Description (facultatif)"
                        className="w-full border rounded-md p-2 mb-4"
                    />
                    <button
                        onClick={handleSubmitReview}
                        className="bg-indigo-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-indigo-700 w-full"
                    >
                        Soumettre
                    </button>
                </Modal>
            )}
        </div>
    );
}
