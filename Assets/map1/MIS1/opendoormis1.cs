using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class opendoormis1 : MonoBehaviour
{
    public GameObject iteam ;
    bool save1 = false;
    bool save2 = false;
    bool save3 = false;
    bool save4 = false;

    void Start()
    {
        Debug.Log("ssssssssssss");   
    }
    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "handle1") {
            save1 = true;
        }
        if (other.tag == "handle2")
        {
            save2 = true;
        }
        if (other.tag == "handle3")
        {
            save3 = true;
        }
        if (other.tag == "handle4")
        {
            save4 = true;
        }
        if (save1 && save2 && save3 && save4 )
        {
            iteam.transform.Rotate(0, -45, 0);
        }
    }
}
