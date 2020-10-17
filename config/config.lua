Config = {
    Locations = {
        [1] = {
            ["Blip"] = { --> Position du blip coiffeur.
                ["x"] = 137.29, ["y"] = -1710.37, ["z"] = 29.1
            },

            ["menuPos"] = { 
                ["x"] = 137.29, ["y"] = -1710.37, ["z"] = 29.1
            },

            ["Homme"] = { 
                ["Coupe"] = {
                    ["Chauve"] = {0, 5}, --> DrawID, Prix.
                    ["Court"] = {1, 5}, --> DrawID, Prix.
                    ["Petite crète"] = {2, 5}, --> DrawID, Prix.
                    ["Dégradé"] = {3, 5}, --> DrawID, Prix.
                },

                ["Couleur"] = {
                    ["Couleur #1"] = {1, 5}, --> CouleurID, Prix.
                    ["Couleur #2"] = {2, 5}, --> CouleurID, Prix.
                    ["Couleur #3"] = {3, 5}, --> CouleurID, Prix.
                    ["Couleur #4"] = {4, 5}, --> CouleurID, Prix.
                    ["Couleur #5"] = {5, 5}, --> CouleurID, Prix.
                },
            },

            ["Femme"] = {
                ["Coupe"] = {
                    ["A vous de continuer.."] = {0, 5}, --> DrawID, Prix.
                },

                ["Couleur"] = {
                    ["Couleur #1"] = {1, 5}, --> CouleurID, Prix.
                },
            }
        },
    },
}