using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class chcekLL : MonoBehaviour
{
    public GameObject dailoguse ;
    public GameObject dailog ;
    public GameObject f1_1;
    public GameObject f2_2;
    public Button close;
    // Start is called before the first frame update
    private void Start()
    {
        Button btnclose = close.GetComponent<Button>();
        btnclose.onClick.AddListener(closedailog);
    }
    private void OnTriggerStay(Collider other)
    {
        if (other.tag == ("Player"))
        {
            dailoguse.SetActive(true);
            if (Input.GetKey(KeyCode.E))
            {
                if ((f1_1.active.Equals(true)) && f2_2.active.Equals(true))
                {
                    Debug.Log("pass");
                }
                else
                {
                    dailog.SetActive(true);
                }
            }
        }

    }
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == ("Player"))
        {
            dailoguse.SetActive(false);
            dailog.SetActive(false);
        }
    }
    void closedailog()
    {
        dailog.SetActive(false);
    }
}
