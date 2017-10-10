% G = tf (0.3, [1, 0.1, 0]);
G = tf (0.01, [0.005, 0.065, 0.1001]);
C = pidtune (G, 'PI' );
pidTuner (G, C)