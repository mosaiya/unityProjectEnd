using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dooropen : MonoBehaviour
{
    public bool Open = false;
    public float doorOpen = 90f;
    public float doorClose = 0f;
    public float smooth = 2f;
    // Start is called before the first frame update
    void Start()
    {

    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            Open = !Open;
        }
        else
        {

            Open = !Open;
        }
    }
    // Update is called once per frame
    void Update()
    {
        if (Open)
        {
            Debug.Log("o");
            Quaternion targerRotation = Quaternion.Euler(0,doorOpen, 0);
            transform.localRotation = Quaternion.Slerp(transform.localRotation, targerRotation, smooth * Time.deltaTime);
        }
        else
        {
            Quaternion targerRotation2 = Quaternion.Euler(0,  doorClose,0);
            transform.localRotation = Quaternion.Slerp(transform.localRotation, targerRotation2, smooth * Time.deltaTime);

        }
    }
}

