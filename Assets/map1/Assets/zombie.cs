using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityStandardAssets.CrossPlatformInput;

public   class  zombie  : MonoBehaviour
{
    float Hp = 100f;
    public Image healthBar;
    float maxHealth = 100f;
    public GameObject countzombie;
    void Update()
    {
        healthBar.fillAmount = Hp / maxHealth;
       if (Hp <= 0)
        {
            Destroy(gameObject);
            countzombie.SetActive(false);
        }     
    }
    void OnParticleCollision(GameObject other)
    {
        Debug.Log("hit");
        Hp -= ramdom() ;
    }

     float ramdom()
    {
        return Random.Range(3f,7f);
    }
}
