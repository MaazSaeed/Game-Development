using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager instance;

    public AudioSource jumpSound;
    public AudioSource hurtSound;
    public AudioSource scoreSound;

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject); // Keeps the AudioManager alive across scenes
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void PlayJumpSound()
    {
        jumpSound.Play();
    }

    public void PlayHurtSound()
    {
        hurtSound.Play();
    }
    public void PlayScoreSound()
    {
        scoreSound.Play();
    }
}
