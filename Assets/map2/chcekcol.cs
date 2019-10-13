using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class chcekcol : MonoBehaviour
{
    public GameObject chcek;
    void OnTriggerEnter(Collider other)
    {
           if (other.tag == "Player")
        {
            chcek.SetActive(true);
        }    
    }
}
