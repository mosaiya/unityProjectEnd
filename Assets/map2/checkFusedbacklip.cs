using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class checkFusedbacklip : MonoBehaviour
{
    public GameObject dailog;
    public Button close2;
    public bool checkEz;
    void Start()
    {
        Button btnclose = close2.GetComponent<Button>();
        btnclose.onClick.AddListener(closedailogBacklip);
    }
    private void OnTriggerStay(Collider other)
    {
        if (other.tag == ("Player"))
        {
            dailog.SetActive(true);
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == ("Player"))
        {
            dailog.SetActive(false);
        }
    }
    void closedailogBacklip ()
    {
        dailog.SetActive(false);
        
    }
}
