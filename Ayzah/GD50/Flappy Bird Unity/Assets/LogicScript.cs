using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LogicScript : MonoBehaviour
{
    public int playerScore = 0;
    public Text scoreText;
    public GameObject GameOverScreen;
    private bool gameOngoing = true;

    //[ContextMenu("Increase Score")]
    public void addScore(int incrementalValue)
    {
        if (gameOngoing)
        {
            playerScore += incrementalValue;
            scoreText.text = playerScore.ToString();
            AudioManager.instance.PlayScoreSound();
        }
    }

    public void restartGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public void gameOver()
    {
        GameOverScreen.SetActive(true);
        gameOngoing = false;
    }
}
